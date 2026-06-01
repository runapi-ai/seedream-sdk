import type { AsyncTaskStatus } from '@runapi.ai/core';

export type SeedreamModel =
  | 'seedream-4.5-text-to-image'
  | 'seedream-4.5-edit'
  | 'seedream-5-lite-text-to-image'
  | 'seedream-5-lite-edit'
  | 'seedream-v4-text-to-image'
  | 'seedream-v4-edit';

export type TextToImageModel =
  | 'seedream-4.5-text-to-image'
  | 'seedream-5-lite-text-to-image'
  | 'seedream-v4-text-to-image';

export type EditImageModel =
  | 'seedream-4.5-edit'
  | 'seedream-5-lite-edit'
  | 'seedream-v4-edit';

export type AspectRatio = '1:1' | '4:3' | '3:4' | '16:9' | '9:16' | '2:3' | '3:2' | '21:9';
export type OutputQuality = 'basic' | 'high';
export type V4OutputResolution = '1k' | '2k' | '4k';

interface ImageGenerationBaseParams {
  prompt: string;
  aspect_ratio: AspectRatio;
  output_quality: OutputQuality;
  enable_safety_checker?: boolean;
  callback_url?: string;
}

interface V4GenerationBaseParams {
  prompt: string;
  aspect_ratio?: AspectRatio;
  output_resolution?: V4OutputResolution;
  output_count?: number;
  seed?: number;
  enable_safety_checker?: boolean;
  callback_url?: string;
}

export interface Generation45TextParams extends ImageGenerationBaseParams {
  model: 'seedream-4.5-text-to-image';
}

export interface Generation45EditImageParams extends ImageGenerationBaseParams {
  model: 'seedream-4.5-edit';
  source_image_urls: string[];
}

export interface Generation5LiteTextParams extends ImageGenerationBaseParams {
  model: 'seedream-5-lite-text-to-image';
}

export interface Generation5LiteEditParams extends ImageGenerationBaseParams {
  model: 'seedream-5-lite-edit';
  source_image_urls: string[];
}

export interface GenerationV4TextParams extends V4GenerationBaseParams {
  model: 'seedream-v4-text-to-image';
}

export interface GenerationV4EditParams extends V4GenerationBaseParams {
  model: 'seedream-v4-edit';
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
