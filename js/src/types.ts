import type { AsyncTaskStatus } from '@runapi.ai/core';

export type SeedreamModel =
  | 'seedream-4.5-text-to-image'
  | 'seedream-4.5-edit'
  | 'seedream-5-lite-text-to-image'
  | 'seedream-5-lite-image-to-image';

export type AspectRatio = '1:1' | '4:3' | '3:4' | '16:9' | '9:16' | '2:3' | '3:2' | '21:9';
export type Quality = 'basic' | 'high';

interface GenerationBaseParams {
  prompt: string;
  aspect_ratio: AspectRatio;
  quality: Quality;
  callback_url?: string;
}

export interface Generation45TextParams extends GenerationBaseParams {
  model: 'seedream-4.5-text-to-image';
}

export interface Generation45EditImageParams extends GenerationBaseParams {
  model: 'seedream-4.5-edit';
  image_urls: string[];
}

export interface Generation5LiteTextParams extends GenerationBaseParams {
  model: 'seedream-5-lite-text-to-image';
  nsfw_checker?: boolean;
}

export interface Generation5LiteImageParams extends GenerationBaseParams {
  model: 'seedream-5-lite-image-to-image';
  image_urls: string[];
  nsfw_checker?: boolean;
}

export type TextToImageParams =
  | Generation45TextParams
  | Generation45EditImageParams
  | Generation5LiteTextParams
  | Generation5LiteImageParams;

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

/**
 * Resolved response returned by the `run()` method after polling sees
 * `status: 'completed'`. Narrows the base response so `images` is
 * guaranteed non-optional in user code.
 */
export type CompletedTextToImageResponse = TextToImageResponse & {
  status: 'completed';
  images: Image[];
};
