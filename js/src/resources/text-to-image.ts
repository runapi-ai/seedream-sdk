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

export class TextToImage {
  constructor(private readonly http: HttpClient) {}

  async run(params: TextToImageParams, options?: RequestOptions & PollingOptions): Promise<CompletedTextToImageResponse> {
    const { id } = await this.create(params, options);
    const response = await pollUntilComplete<TextToImageResponse>(() => this.get(id, options), {
      maxWaitMs: options?.maxWaitMs,
      pollIntervalMs: options?.pollIntervalMs,
    });
    return response as CompletedTextToImageResponse;
  }

  async create(params: TextToImageParams, options?: RequestOptions): Promise<TaskCreateResponse> {
    return this.http.request<TaskCreateResponse>('POST', ENDPOINT, {
      body: compactParams(params),
      ...options,
    });
  }

  async get(id: string, options?: RequestOptions): Promise<TextToImageResponse> {
    return this.http.request<TextToImageResponse>('GET', `${ENDPOINT}/${id}`, {
      ...options,
    });
  }
}
