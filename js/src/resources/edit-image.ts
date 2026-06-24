import type { HttpClient, RequestOptions, PollingOptions, ActionSchema } from '@runapi.ai/core';
import { compactParams, validateParams } from '@runapi.ai/core';
import { pollUntilComplete } from '@runapi.ai/core/internal';
import { contract } from '../contract_gen';
import type {
  CompletedEditImageResponse,
  EditImageParams,
  EditImageResponse,
  TaskCreateResponse,
} from '../types';

const ENDPOINT = '/api/v1/seedream/edit_image';

/**
 * Modifies source images according to a text prompt.
 * V4 models accept up to 10 source images; 4.5 and 5-lite accept up to 14.
 */
export class EditImage {
  constructor(private readonly http: HttpClient) {}

  /**
   * Create an edit image task and wait until complete.
   * @param params Edit image parameters.
   * @param options Per-request and polling overrides.
   * @returns The completed edit image response.
   */
  async run(params: EditImageParams, options?: RequestOptions & PollingOptions): Promise<CompletedEditImageResponse> {
    const { id } = await this.create(params, options);
    const response = await pollUntilComplete<EditImageResponse>(() => this.get(id, options), {
      maxWaitMs: options?.maxWaitMs,
      pollIntervalMs: options?.pollIntervalMs,
    });
    return response as CompletedEditImageResponse;
  }

  /**
   * Create an edit image task; returns immediately with a task id.
   * @param params Edit image parameters.
   * @param options Per-request overrides.
   * @returns The task creation result.
   */
  async create(params: EditImageParams, options?: RequestOptions): Promise<TaskCreateResponse> {
    const body = compactParams(params);
    validateParams(contract['edit-image'] as ActionSchema, body as Record<string, unknown>);
    return this.http.request<TaskCreateResponse>('POST', ENDPOINT, {
      body,
      ...options,
    });
  }

  /**
   * Fetch the current status of an edit image task.
   * @param id The task id.
   * @param options Per-request overrides.
   * @returns The current edit image task status.
   */
  async get(id: string, options?: RequestOptions): Promise<EditImageResponse> {
    return this.http.request<EditImageResponse>('GET', `${ENDPOINT}/${id}`, {
      ...options,
    });
  }
}
