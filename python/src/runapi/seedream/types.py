"""Seedream response models."""

from __future__ import annotations

from runapi.core import BaseModel, TaskResponse, optional, required


class Image(BaseModel):
    url = optional(str)


class BoundingBox(BaseModel):
    """Bounding box describing a layer's position within the base image."""

    absolute = optional([int])
    normalized = optional([int])


class Layer(BaseModel):
    """A decomposed layer with its position and metadata."""

    url = required(str)
    z_index = required(int)
    bounding_box = optional(lambda: BoundingBox)
    name = optional(str)
    description = optional(str)


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


class DecomposeLayersResponse(TaskResponse):
    """Seedream layer decomposition task status response."""

    id = required(str)
    status = optional(str, enum=lambda: TaskResponse.Status.ALL)
    base_image = optional(lambda: Image)
    layers = optional([lambda: Layer])
    error = optional(str)


class CompletedDecomposeLayersResponse(DecomposeLayersResponse):
    """Narrowed response once layer decomposition completes."""

    base_image = required(lambda: Image)
    layers = required([lambda: Layer])
