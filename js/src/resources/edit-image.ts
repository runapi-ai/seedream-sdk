import type { HttpClient, RequestOptions, PollingOptions } from '@runapi.ai/core';
import { compactParams } from '@runapi.ai/core';
import { pollUntilComplete } from '@runapi.ai/core/internal';
import type {
  CompletedEditImageResponse,
  EditImageParams,
  EditImageResponse,
  TaskCreateResponse,
} from '../types';

const ENDPOINT = '/api/v1/seedream/edit_image';

export class EditImage {
  constructor(private readonly http: HttpClient) {}

  async run(params: EditImageParams, options?: RequestOptions & PollingOptions): Promise<CompletedEditImageResponse> {
    const { id } = await this.create(params, options);
    const response = await pollUntilComplete<EditImageResponse>(() => this.get(id, options), {
      maxWaitMs: options?.maxWaitMs,
      pollIntervalMs: options?.pollIntervalMs,
    });
    return response as CompletedEditImageResponse;
  }

  async create(params: EditImageParams, options?: RequestOptions): Promise<TaskCreateResponse> {
    return this.http.request<TaskCreateResponse>('POST', ENDPOINT, {
      body: compactParams(params),
      ...options,
    });
  }

  async get(id: string, options?: RequestOptions): Promise<EditImageResponse> {
    return this.http.request<EditImageResponse>('GET', `${ENDPOINT}/${id}`, {
      ...options,
    });
  }
}
