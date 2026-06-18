import type { AsyncTaskStatus } from '@runapi.ai/core';

/** Union of all Seedream model identifiers across text-to-image and edit endpoints. */
export type SeedreamModel =
  | 'seedream-4.5-text-to-image'
  | 'seedream-4.5-edit'
  | 'seedream-5-lite-text-to-image'
  | 'seedream-5-lite-edit'
  | 'seedream-v4-text-to-image'
  | 'seedream-v4-edit';

/** Models accepted by the text-to-image endpoint. */
export type TextToImageModel =
  | 'seedream-4.5-text-to-image'
  | 'seedream-5-lite-text-to-image'
  | 'seedream-v4-text-to-image';

/** Models accepted by the edit-image endpoint. */
export type EditImageModel =
  | 'seedream-4.5-edit'
  | 'seedream-5-lite-edit'
  | 'seedream-v4-edit';

export type AspectRatio = '1:1' | '4:3' | '3:4' | '16:9' | '9:16' | '2:3' | '3:2' | '21:9';
/** Quality preset for 4.5 and 5-lite models. */
export type OutputQuality = 'basic' | 'high';
/** Pixel resolution tier for V4 models. */
export type V4OutputResolution = '1k' | '2k' | '4k';

/**
 * Shared parameters for 4.5 and 5-lite models.
 * Both `aspect_ratio` and `output_quality` are required for these model families.
 */
interface ImageGenerationBaseParams {
  prompt: string;
  aspect_ratio: AspectRatio;
  output_quality: OutputQuality;
  /** Toggle content safety filtering. */
  enable_safety_checker?: boolean;
  callback_url?: string;
}

/**
 * Shared parameters for V4 models.
 * Uses `output_resolution` instead of `output_quality`, and supports
 * reproducible generation via `seed` and batch output via `output_count`.
 */
interface V4GenerationBaseParams {
  prompt: string;
  aspect_ratio?: AspectRatio;
  /** Output resolution tier (default: "1k"). */
  output_resolution?: V4OutputResolution;
  /** Number of images to generate (default: 1). */
  output_count?: number;
  /** Fixed seed for reproducible generation. */
  seed?: number;
  /** Toggle content safety filtering. */
  enable_safety_checker?: boolean;
  callback_url?: string;
}

export interface Generation45TextParams extends ImageGenerationBaseParams {
  model: 'seedream-4.5-text-to-image';
}

export interface Generation45EditImageParams extends ImageGenerationBaseParams {
  model: 'seedream-4.5-edit';
  /** Source image URLs to edit (up to 14 for 4.5 models). */
  source_image_urls: string[];
}

export interface Generation5LiteTextParams extends ImageGenerationBaseParams {
  model: 'seedream-5-lite-text-to-image';
}

export interface Generation5LiteEditParams extends ImageGenerationBaseParams {
  model: 'seedream-5-lite-edit';
  /** Source image URLs to edit (up to 14 for 5-lite models). */
  source_image_urls: string[];
}

export interface GenerationV4TextParams extends V4GenerationBaseParams {
  model: 'seedream-v4-text-to-image';
}

export interface GenerationV4EditParams extends V4GenerationBaseParams {
  model: 'seedream-v4-edit';
  /** Source image URLs to edit (up to 10 for V4 models). */
  source_image_urls: string[];
}

export type TextToImageParams =
  | Generation45TextParams
  | Generation5LiteTextParams
  | GenerationV4TextParams;

export type EditImageParams =
  | Generation45EditImageParams
  | Generation5LiteEditParams
  | GenerationV4EditParams;

export interface TaskCreateResponse {
  id: string;
}

/** A generated image with its CDN URL. */
export interface Image {
  url: string;
}

export interface TextToImageResponse {
  id: string;
  status: AsyncTaskStatus;
  images?: Image[];
  error?: string;
  [key: string]: unknown;
}

export type EditImageResponse = TextToImageResponse;

/**
 * Resolved response returned by the `run()` method after polling sees
 * `status: 'completed'`. Narrows the base response so `images` is
 * guaranteed non-optional in user code.
 */
export type CompletedTextToImageResponse = TextToImageResponse & {
  status: 'completed';
  images: Image[];
};

export type CompletedEditImageResponse = EditImageResponse & {
  status: 'completed';
  images: Image[];
};
