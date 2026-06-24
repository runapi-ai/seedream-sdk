"""Seedream model lists, enums, and response models."""

from __future__ import annotations

from runapi.core import BaseModel, TaskResponse, optional, required

# Model groupings used by bespoke prompt-length selection (per-model rule the
# contract cannot express). Model membership and field enums are validated by
# the generated CONTRACT.
LITE_MODELS = ["seedream-5-lite-text-to-image", "seedream-5-lite-edit"]
V4_MODELS = ["seedream-v4-text-to-image", "seedream-v4-edit"]


class Image(BaseModel):
    url = optional(str)


class TextToImageResponse(TaskResponse):
    """Seedream image task status response."""

    id = required(str)
    status = optional(str, enum=lambda: TaskResponse.Status.ALL)
    images = optional([lambda: Image])
    error = optional(str)


EditImageResponse = TextToImageResponse


class CompletedTextToImageResponse(TextToImageResponse):
    """Narrowed response from ``run()`` once polling observes completion."""

    images = required([lambda: Image])


CompletedEditImageResponse = CompletedTextToImageResponse
