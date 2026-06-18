import type { HttpClient, RequestOptions, PollingOptions } from '@runapi.ai/core';
import { compactParams } from '@runapi.ai/core';
import { pollUntilComplete } from '@runapi.ai/core/internal';
import type {
  CompletedTextToImageResponse,
  TextToImageParams,
  TextToImageResponse,
  TaskCreateResponse,
} from '../types';

const ENDPOINT = '/api/v1/seedream/text_to_image';

/**
 * Generates images from text prompts across Seedream model versions.
 * Field requirements vary by model family: 4.5/5-lite require `aspect_ratio`
 * and `output_quality`; V4 uses `output_resolution` and supports `seed`/`output_count`.
 */
export class TextToImage {
  constructor(private readonly http: HttpClient) {}

  /**
   * Create a text to image task and wait until complete.
   * @param params Text to image parameters.
   * @param options Per-request and polling overrides.
   * @returns The completed text to image response.
   */
  async run(params: TextToImageParams, options?: RequestOptions & PollingOptions): Promise<CompletedTextToImageResponse> {
    const { id } = await this.create(params, options);
    const response = await pollUntilComplete<TextToImageResponse>(() => this.get(id, options), {
      maxWaitMs: options?.maxWaitMs,
      pollIntervalMs: options?.pollIntervalMs,
    });
    return response as CompletedTextToImageResponse;
  }

  /**
   * Create a text to image task; returns immediately with a task id.
   * @param params Text to image parameters.
   * @param options Per-request overrides.
   * @returns The task creation result.
   */
  async create(params: TextToImageParams, options?: RequestOptions): Promise<TaskCreateResponse> {
    return this.http.request<TaskCreateResponse>('POST', ENDPOINT, {
      body: compactParams(params),
      ...options,
    });
  }

  /**
   * Fetch the current status of a text to image task.
   * @param id The task id.
   * @param options Per-request overrides.
   * @returns The current text to image task status.
   */
  async get(id: string, options?: RequestOptions): Promise<TextToImageResponse> {
    return this.http.request<TextToImageResponse>('GET', `${ENDPOINT}/${id}`, {
      ...options,
    });
  }
}
