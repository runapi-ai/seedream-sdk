import type { HttpClient, RequestOptions, PollingOptions } from '@runapi.ai/core';
import { compactParams } from '@runapi.ai/core';
import { pollUntilComplete } from '@runapi.ai/core/internal';
import type {
  CompletedDecomposeLayersResponse,
  DecomposeLayersParams,
  DecomposeLayersResponse,
  TaskCreateResponse,
} from '../types';

const ENDPOINT = '/api/v1/seedream/decompose_layers';

/** Separates one image into a base image and independent transparent layers. */
export class DecomposeLayers {
  constructor(private readonly http: HttpClient) {}

  async run(params: DecomposeLayersParams, options?: RequestOptions & PollingOptions): Promise<CompletedDecomposeLayersResponse> {
    const { id } = await this.create(params, options);
    return pollUntilComplete<DecomposeLayersResponse>(() => this.get(id, options), {
      maxWaitMs: options?.maxWaitMs,
      pollIntervalMs: options?.pollIntervalMs,
    }) as Promise<CompletedDecomposeLayersResponse>;
  }

  async create(params: DecomposeLayersParams, options?: RequestOptions): Promise<TaskCreateResponse> {
    const body = compactParams(params);
    return this.http.request<TaskCreateResponse>('POST', ENDPOINT, { body, ...options });
  }

  async get(id: string, options?: RequestOptions): Promise<DecomposeLayersResponse> {
    return this.http.request<DecomposeLayersResponse>('GET', `${ENDPOINT}/${id}`, { ...options });
  }
}
