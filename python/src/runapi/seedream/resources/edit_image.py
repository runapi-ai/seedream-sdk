"""Seedream edit-image resource."""

from __future__ import annotations

from typing import Any, Dict, Optional

from runapi.core import Resource, ValidationError, RequestOptions

from ..contract_gen import CONTRACT
from ..types import (
    LONG_PROMPT_MODELS,
    MINIMUM_THREE_PROMPT_MODELS,
    TEN_SOURCE_IMAGE_MODELS,
    V4_MODELS,
    CompletedEditImageResponse,
    EditImageResponse,
)


class EditImage(Resource):
    """Edit images from a prompt and source images with Seedream models."""

    ENDPOINT = "/api/v1/seedream/edit_image"

    RESPONSE_CLASS = EditImageResponse
    COMPLETED_RESPONSE_CLASS = CompletedEditImageResponse

    PROMPT_MAX_LENGTH = 3000
    V4_PROMPT_MAX_LENGTH = 5000
    PROMPT_MIN_LENGTH_LITE = 3

    def run(self, options: Optional[RequestOptions] = None, **params: Any) -> Any:
        """Edit an image and poll until it completes.

        Args:
            **params: image edit parameters (model, ...).

        Returns:
            The completed (narrowed) image edit response.
        """
        task = self.create(options=options, **params)
        return self._poll_until_complete(lambda: self.get(task.id, options=options))

    def create(self, options: Optional[RequestOptions] = None, **params: Any) -> Any:
        """Create an image editing task and return immediately with an id.

        Args:
            **params: image edit parameters (model, ...).

        Returns:
            The task creation result with an id.
        """
        compacted = self._compact_params(params)
        self._validate_params(compacted)
        return self._request("post", self.ENDPOINT, body=compacted, options=options)

    def get(self, id: str, options: Optional[RequestOptions] = None) -> Any:
        """Fetch the current status of an image editing task.

        Args:
            id: The task id returned by ``create``.

        Returns:
            The current task status.
        """
        return self._request("get", f"{self.ENDPOINT}/{id}", options=options)

    def _validate_params(self, params: Dict[str, Any]) -> None:
        self._validate_contract(CONTRACT["edit-image"], params)

        model = params.get("model")

        prompt = params.get("prompt")
        if not (isinstance(prompt, str) and prompt):
            raise ValidationError("prompt is required")
        max_length = self.V4_PROMPT_MAX_LENGTH if model in LONG_PROMPT_MODELS else self.PROMPT_MAX_LENGTH
        if len(prompt) > max_length:
            raise ValidationError(f"prompt must be at most {max_length} characters")
        if model in MINIMUM_THREE_PROMPT_MODELS and len(prompt) < self.PROMPT_MIN_LENGTH_LITE:
            raise ValidationError(
                f"prompt must be between {self.PROMPT_MIN_LENGTH_LITE} and {max_length} characters"
            )

        source_image_urls = params.get("source_image_urls")
        source_image_max = 10 if model in TEN_SOURCE_IMAGE_MODELS else 14
        if isinstance(source_image_urls, list) and len(source_image_urls) > source_image_max:
            raise ValidationError(f"source_image_urls accepts at most {source_image_max} images")

        if model in V4_MODELS:
            self._validate_integer(params, "seed")

    @staticmethod
    def _validate_integer(params: Dict[str, Any], key: str) -> None:
        value = params.get(key)
        if value is None:
            return
        if isinstance(value, int) and not isinstance(value, bool):
            return
        raise ValidationError(f"{key} must be an integer")
