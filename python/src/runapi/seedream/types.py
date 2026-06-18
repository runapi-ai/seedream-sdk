"""Seedream model lists, enums, and response models."""

from __future__ import annotations

from runapi.core import BaseModel, TaskResponse, optional, required

MODELS = [
    "seedream-4.5-text-to-image",
    "seedream-4.5-edit",
    "seedream-5-lite-text-to-image",
    "seedream-5-lite-edit",
    "seedream-v4-text-to-image",
    "seedream-v4-edit",
]
TEXT_TO_IMAGE_MODELS = [
    "seedream-4.5-text-to-image",
    "seedream-5-lite-text-to-image",
    "seedream-v4-text-to-image",
]
EDIT_MODELS = ["seedream-4.5-edit", "seedream-5-lite-edit", "seedream-v4-edit"]
LITE_MODELS = ["seedream-5-lite-text-to-image", "seedream-5-lite-edit"]
V4_MODELS = ["seedream-v4-text-to-image", "seedream-v4-edit"]
ASPECT_RATIOS = ["1:1", "4:3", "3:4", "16:9", "9:16", "2:3", "3:2", "21:9"]
OUTPUT_QUALITIES = ["basic", "high"]
V4_OUTPUT_RESOLUTIONS = ["1k", "2k", "4k"]


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
