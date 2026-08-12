import { BaseClient, type ClientOptions } from '@runapi.ai/core';
import { TextToImage } from './resources/text-to-image';
import { EditImage } from './resources/edit-image';
import { DecomposeLayers } from './resources/decompose-layers';

/**
 * Seedream image generation and editing API client.
 *
 * Three model families with different field requirements:
 * - **4.5**: requires `aspect_ratio` and `output_quality`
 * - **5-lite**: same required fields as 4.5, faster generation
 * - **V4**: uses `output_resolution` instead; supports `seed` and batch `output_count`
 *
 * @example
 * ```typescript
 * const client = new SeedreamClient({ apiKey: 'your-api-key' });
 *
 * // Seedream 4.5
 * const result = await client.textToImage.run({
 *   model: 'seedream-4.5-text-to-image',
 *   prompt: 'A beautiful product render',
 *   aspect_ratio: '16:9',
 *   output_quality: 'high',
 * });
 *
 * // Seedream V4 with batch output
 * const batch = await client.textToImage.run({
 *   model: 'seedream-v4-text-to-image',
 *   prompt: 'Minimalist logo design',
 *   output_count: 4,
 * });
 * ```
 */
export class SeedreamClient extends BaseClient {
  /** Text-to-image generation across Seedream model versions. */
  public readonly textToImage: TextToImage;
  /** Edit source images according to a text prompt. */
  public readonly editImage: EditImage;
  /** Separate an image into a base image and independent layers. */
  public readonly decomposeLayers: DecomposeLayers;

  constructor(options: ClientOptions = {}) {
    super(options);
    this.textToImage = new TextToImage(this.http);
    this.editImage = new EditImage(this.http);
    this.decomposeLayers = new DecomposeLayers(this.http);
  }
}
