"""Seedream edit-image resource."""

from __future__ import annotations

from typing import Any, Dict

from runapi.core import Resource, ValidationError

from ..types import (
    ASPECT_RATIOS,
    EDIT_MODELS,
    LITE_MODELS,
    OUTPUT_QUALITIES,
    V4_MODELS,
    V4_OUTPUT_RESOLUTIONS,
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
    V4_OUTPUT_COUNT_RANGE = range(1, 7)

    def run(self, **params: Any) -> Any:
        """Edit an image and poll until it completes.

        Args:
            **params: image edit parameters (model, ...).

        Returns:
            The completed (narrowed) image edit response.
        """
        task = self.create(**params)
        return self._poll_until_complete(lambda: self.get(task.id))

    def create(self, **params: Any) -> Any:
        """Create an image editing task and return immediately with an id.

        Args:
            **params: image edit parameters (model, ...).

        Returns:
            The task creation result with an id.
        """
        compacted = self._compact_params(params)
        self._validate_params(compacted)
        return self._request("post", self.ENDPOINT, body=compacted)

    def get(self, id: str) -> Any:
        """Fetch the current status of an image editing task.

        Args:
            id: The task id returned by ``create``.

        Returns:
            The current task status.
        """
        return self._request("get", f"{self.ENDPOINT}/{id}")

    def _validate_params(self, params: Dict[str, Any]) -> None:
        model = params.get("model")
        if not model:
            raise ValidationError("model is required")
        if model not in EDIT_MODELS:
            raise ValidationError(f"Invalid model: {model}. Must be one of: {', '.join(EDIT_MODELS)}")

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

        if not self._field_present(params, "source_image_urls"):
            raise ValidationError("source_image_urls is required")

        if model in V4_MODELS:
            self._validate_optional(params, "aspect_ratio", ASPECT_RATIOS)
            self._validate_optional(params, "output_resolution", V4_OUTPUT_RESOLUTIONS)
            self._validate_integer_range(params, "output_count", self.V4_OUTPUT_COUNT_RANGE)
            self._validate_integer(params, "seed")
        else:
            self._validate_required(params, "aspect_ratio")
            self._validate_required(params, "output_quality")
            self._validate_optional(params, "aspect_ratio", ASPECT_RATIOS)
            self._validate_optional(params, "output_quality", OUTPUT_QUALITIES)

    def _validate_required(self, params: Dict[str, Any], key: str) -> None:
        if not self._field_present(params, key):
            raise ValidationError(f"{key} is required")

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

    @staticmethod
    def _validate_integer_range(params: Dict[str, Any], key: str, allowed: range) -> None:
        value = params.get(key)
        if value is None:
            return
        if isinstance(value, int) and not isinstance(value, bool) and value in allowed:
            return
        raise ValidationError(f"{key} must be between {allowed.start} and {allowed.stop - 1}")
