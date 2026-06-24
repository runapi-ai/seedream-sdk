"""Seedream text-to-image resource."""

from __future__ import annotations

from typing import Any, Dict

from runapi.core import Resource, ValidationError

from ..contract_gen import CONTRACT
from ..types import (
    LITE_MODELS,
    V4_MODELS,
    CompletedTextToImageResponse,
    TextToImageResponse,
)


class TextToImage(Resource):
    """Generate images from text prompts with Seedream models."""

    ENDPOINT = "/api/v1/seedream/text_to_image"

    RESPONSE_CLASS = TextToImageResponse
    COMPLETED_RESPONSE_CLASS = CompletedTextToImageResponse

    PROMPT_MAX_LENGTH = 3000
    V4_PROMPT_MAX_LENGTH = 5000
    PROMPT_MIN_LENGTH_LITE = 3

    def run(self, **params: Any) -> Any:
        """Create a text-to-image task and poll until it completes.

        Args:
            **params: text-to-image parameters (model, ...).

        Returns:
            The completed (narrowed) text-to-image response.
        """
        task = self.create(**params)
        return self._poll_until_complete(lambda: self.get(task.id))

    def create(self, **params: Any) -> Any:
        """Create a text-to-image task and return immediately with an id.

        Args:
            **params: text-to-image parameters (model, ...).

        Returns:
            The task creation result with an id.
        """
        compacted = self._compact_params(params)
        self._validate_params(compacted)
        return self._request("post", self.ENDPOINT, body=compacted)

    def get(self, id: str) -> Any:
        """Fetch the current status of a text-to-image task.

        Args:
            id: The task id returned by ``create``.

        Returns:
            The current task status.
        """
        return self._request("get", f"{self.ENDPOINT}/{id}")

    def _validate_params(self, params: Dict[str, Any]) -> None:
        self._validate_contract(CONTRACT["text-to-image"], params)

        model = params.get("model")

        prompt = params.get("prompt")
        if not (isinstance(prompt, str) and prompt):
            raise ValidationError("prompt is required")
        max_length = self.V4_PROMPT_MAX_LENGTH if model in V4_MODELS else self.PROMPT_MAX_LENGTH
        if len(prompt) > max_length:
            raise ValidationError(f"prompt must be at most {max_length} characters")
        if model in LITE_MODELS and len(prompt) < self.PROMPT_MIN_LENGTH_LITE:
            raise ValidationError(
                f"prompt must be between {self.PROMPT_MIN_LENGTH_LITE} and {self.PROMPT_MAX_LENGTH} characters"
            )

        if model in V4_MODELS:
            self._validate_integer(params, "seed")

        if self._field_present(params, "source_image_urls"):
            raise ValidationError(f"source_image_urls is not supported for {model}")

    @staticmethod
    def _field_present(params: Dict[str, Any], key: str) -> bool:
        value = params.get(key)
        if value is None:
            return False
        if hasattr(value, "__len__"):
            return len(value) > 0
        return True

    @staticmethod
    def _validate_integer(params: Dict[str, Any], key: str) -> None:
        value = params.get(key)
        if value is None:
            return
        if isinstance(value, int) and not isinstance(value, bool):
            return
        raise ValidationError(f"{key} must be an integer")
