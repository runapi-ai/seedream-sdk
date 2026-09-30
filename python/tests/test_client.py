import json

import httpx
import pytest

from runapi.core import config
from runapi.core.errors import AuthenticationError, ValidationError
from runapi.core.http_client import HttpClient
from runapi.core.options import ClientOptions
from runapi.seedream import SeedreamClient
from runapi.seedream.resources.edit_image import EditImage
from runapi.seedream.resources.decompose_layers import DecomposeLayers
from runapi.seedream.resources.text_to_image import TextToImage
from runapi.seedream.types import DecomposeLayersResponse, CompletedTextToImageResponse, TextToImageResponse


class FakeHttp:
    def __init__(self, *responses):
        self._responses = list(responses)
        self.calls = []

    def request(self, method, path, body=None, options=None):
        self.calls.append((method, path, body))
        if self._responses:
            return self._responses.pop(0)
        return {"id": "task_1", "status": "pending"}


@pytest.fixture(autouse=True)
def reset_config(monkeypatch):
    monkeypatch.delenv("RUNAPI_API_KEY", raising=False)
    monkeypatch.setattr(config, "api_key", None)
    yield


# --- auth -----------------------------------------------------------------


def test_accepts_api_key_parameter():
    assert isinstance(SeedreamClient(api_key="k", http_client=FakeHttp()), SeedreamClient)


def test_falls_back_to_global(monkeypatch):
    monkeypatch.setattr(config, "api_key", "global-key")
    assert isinstance(SeedreamClient(http_client=FakeHttp()), SeedreamClient)


def test_falls_back_to_env(monkeypatch):
    monkeypatch.setenv("RUNAPI_API_KEY", "env-key")
    assert isinstance(SeedreamClient(http_client=FakeHttp()), SeedreamClient)


def test_raises_without_api_key():
    with pytest.raises(AuthenticationError, match="API key is required"):
        SeedreamClient()


# --- injection / accessors ------------------------------------------------


def test_uses_injected_http_client():
    fake = FakeHttp()
    client = SeedreamClient(api_key="k", http_client=fake)
    assert client.text_to_image._http is fake
    assert client.edit_image._http is fake
    assert client.decompose_layers._http is fake


def test_exposes_resource_accessors():
    client = SeedreamClient(api_key="k", http_client=FakeHttp())
    assert isinstance(client.text_to_image, TextToImage)
    assert isinstance(client.edit_image, EditImage)
    assert isinstance(client.decompose_layers, DecomposeLayers)


def test_decompose_layers_create_get_and_completed_response():
    fake = FakeHttp(
        {"id": "layers-1", "status": "processing"},
        {
            "id": "layers-1",
            "status": "completed", "usage": {"cost": 0.05},
            "base_image": {"url": "https://file.runapi.ai/base.jpeg"},
            "layers": [{"url": "https://file.runapi.ai/layer.png", "z_index": 1}]},
    )
    client = SeedreamClient(api_key="k", http_client=fake)
    created = client.decompose_layers.create(
        model="seedream-5-pro-layer-decomposition",
        image_url="https://cdn.runapi.ai/public/samples/image.jpg",
        output_format="jpeg",
    )
    result = client.decompose_layers.get(created.id)

    assert fake.calls[0] == (
        "post",
        "/api/v1/seedream/decompose_layers",
        {
            "model": "seedream-5-pro-layer-decomposition",
            "image_url": "https://cdn.runapi.ai/public/samples/image.jpg",
            "output_format": "jpeg"},
    )
    assert isinstance(result, DecomposeLayersResponse)
    assert result.base_image.url == "https://file.runapi.ai/base.jpeg"


# --- request shapes -------------------------------------------------------


def test_create_posts_compacted_body():
    fake = FakeHttp({"id": "t1", "status": "pending"})
    client = SeedreamClient(api_key="k", http_client=fake)
    result = client.text_to_image.create(
        model="seedream-v4-text-to-image", prompt="hello world", aspect_ratio="1:1", seed=None
    )
    assert fake.calls == [
        ("post", "/api/v1/seedream/text_to_image", {"model": "seedream-v4-text-to-image", "prompt": "hello world", "aspect_ratio": "1:1"})]
    assert isinstance(result, TextToImageResponse)


def test_lite_output_format_is_forwarded():
    fake = FakeHttp({"id": "t-lite", "status": "pending"})
    client = SeedreamClient(api_key="k", http_client=fake)
    client.edit_image.create(
        model="seedream-5-lite-edit",
        prompt="restyle this image",
        source_image_urls=["https://cdn.runapi.ai/public/samples/image.jpg"],
        aspect_ratio="1:1",
        output_quality="high",
        output_format="jpeg",
    )
    assert fake.calls == [
        (
            "post",
            "/api/v1/seedream/edit_image",
            {
                "model": "seedream-5-lite-edit",
                "prompt": "restyle this image",
                "source_image_urls": ["https://cdn.runapi.ai/public/samples/image.jpg"],
                "aspect_ratio": "1:1",
                "output_quality": "high",
                "output_format": "jpeg"},
        )]


def test_pro_edit_is_forwarded():
    fake = FakeHttp({"id": "t-pro", "status": "pending"})
    client = SeedreamClient(api_key="k", http_client=fake)
    client.edit_image.create(
        model="seedream-5-pro-edit",
        prompt="Turn the material into transparent glass",
        source_image_urls=["https://cdn.runapi.ai/public/samples/image.jpg"],
        aspect_ratio="3:2",
        output_quality="basic",
        output_format="png",
    )
    assert fake.calls[0][2]["model"] == "seedream-5-pro-edit"
    assert fake.calls[0][2]["output_format"] == "png"


def test_get_fetches_by_id():
    fake = FakeHttp({"id": "t1", "status": "processing"})
    client = SeedreamClient(api_key="k", http_client=fake)
    client.text_to_image.get("t1")
    assert fake.calls == [("get", "/api/v1/seedream/text_to_image/t1", None)]


def test_run_narrows_completed_type():
    fake = FakeHttp(
        {"id": "t1", "status": "pending"},
        {"id": "t1", "status": "completed", "usage": {"cost": 0.05}, "images": [{"url": "https://x/y.png"}]},
    )
    client = SeedreamClient(api_key="k", http_client=fake)
    result = client.text_to_image.run(model="seedream-v4-text-to-image", prompt="a serene lake")
    assert isinstance(result, CompletedTextToImageResponse)
    assert result.images[0].url == "https://x/y.png"


def test_server_decides_unknown_models_and_params():
    sent = []

    def handler(request):
        body = json.loads(request.content)
        sent.append(body)
        if body["output_quality"] == "bad":
            return httpx.Response(400, json={"error": "output_quality is not supported"})
        return httpx.Response(200, json={"id": "task_1", "status": "processing"})

    http = HttpClient(
        ClientOptions(api_key="k", base_url="https://runapi.ai", max_retries=0),
        transport=httpx.MockTransport(handler),
    )
    client = SeedreamClient(api_key="k", http_client=http)
    params = {"model": "seedream-future-text-to-image", "prompt": "a lake", "future_setting": "on"}

    result = client.text_to_image.create(**params, output_quality="ultra")
    with pytest.raises(ValidationError) as error:
        client.text_to_image.create(**params, output_quality="bad")

    assert sent[0] == {**params, "output_quality": "ultra"}
    assert result.id == "task_1"
    assert error.value.message == "output_quality is not supported"
