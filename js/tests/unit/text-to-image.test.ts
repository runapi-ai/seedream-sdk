import { describe, it, expect, vi, beforeEach } from 'vitest';
import { TextToImage } from '../../src/resources/text-to-image';
import { EditImage } from '../../src/resources/edit-image';
import type { HttpClient } from '@runapi.ai/core';
import type { TextToImageResponse, TaskCreateResponse } from '../../src/types';

describe('TextToImage', () => {
  const mockHttp: HttpClient = {
    request: vi.fn(),
  };

  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('should send correct request for 4.5 text-to-image', async () => {
    const mockResponse: TaskCreateResponse = { id: 'task-123' };
    vi.mocked(mockHttp.request).mockResolvedValueOnce(mockResponse);

    const textToImage = new TextToImage(mockHttp);
    const result = await textToImage.create({
      model: 'seedream-4.5-text-to-image',
      prompt: 'A beautiful landscape',
      aspect_ratio: '16:9',
      output_quality: 'basic',
    });

    expect(mockHttp.request).toHaveBeenCalledWith('POST', '/api/v1/seedream/text_to_image', {
      body: {
        model: 'seedream-4.5-text-to-image',
        prompt: 'A beautiful landscape',
        aspect_ratio: '16:9',
        output_quality: 'basic',
      },
    });
    expect(result).toEqual(mockResponse);
  });

  it('should send correct request for 5-lite edit', async () => {
    const mockResponse: TaskCreateResponse = { id: 'task-456' };
    vi.mocked(mockHttp.request).mockResolvedValueOnce(mockResponse);

    const editImage = new EditImage(mockHttp);
    await editImage.create({
      model: 'seedream-5-lite-edit',
      prompt: 'Restyle this image',
      source_image_urls: ['https://cdn.runapi.ai/public/samples/image.jpg'],
      aspect_ratio: '1:1',
      output_quality: 'high',
      enable_safety_checker: false,
    });

    expect(mockHttp.request).toHaveBeenCalledWith('POST', '/api/v1/seedream/edit_image', {
      body: {
        model: 'seedream-5-lite-edit',
        prompt: 'Restyle this image',
        source_image_urls: ['https://cdn.runapi.ai/public/samples/image.jpg'],
        aspect_ratio: '1:1',
        output_quality: 'high',
        enable_safety_checker: false,
      },
    });
  });

  it('should send correct request for v4 text-to-image', async () => {
    const mockResponse: TaskCreateResponse = { id: 'task-v4' };
    vi.mocked(mockHttp.request).mockResolvedValueOnce(mockResponse);

    const textToImage = new TextToImage(mockHttp);
    await textToImage.create({
      model: 'seedream-v4-text-to-image',
      prompt: 'A clean product render of a glass teapot',
      aspect_ratio: '16:9',
      output_resolution: '2k',
      output_count: 3,
      seed: 12345,
      enable_safety_checker: true,
    });

    expect(mockHttp.request).toHaveBeenCalledWith('POST', '/api/v1/seedream/text_to_image', {
      body: {
        model: 'seedream-v4-text-to-image',
        prompt: 'A clean product render of a glass teapot',
        aspect_ratio: '16:9',
        output_resolution: '2k',
        output_count: 3,
        seed: 12345,
        enable_safety_checker: true,
      },
    });
  });

  it('should send correct request for v4 edit', async () => {
    const mockResponse: TaskCreateResponse = { id: 'task-v4-edit' };
    vi.mocked(mockHttp.request).mockResolvedValueOnce(mockResponse);

    const editImage = new EditImage(mockHttp);
    await editImage.create({
      model: 'seedream-v4-edit',
      prompt: 'Place the logo on a blue outdoor cap',
      source_image_urls: ['https://cdn.runapi.ai/public/samples/image.jpg'],
      aspect_ratio: '1:1',
      output_resolution: '4k',
      output_count: 1,
      enable_safety_checker: false,
    });

    expect(mockHttp.request).toHaveBeenCalledWith('POST', '/api/v1/seedream/edit_image', {
      body: {
        model: 'seedream-v4-edit',
        prompt: 'Place the logo on a blue outdoor cap',
        source_image_urls: ['https://cdn.runapi.ai/public/samples/image.jpg'],
        aspect_ratio: '1:1',
        output_resolution: '4k',
        output_count: 1,
        enable_safety_checker: false,
      },
    });
  });

  it('should fetch task status by ID', async () => {
    const mockResponse: TextToImageResponse = { id: 'task-123', status: 'processing' };
    vi.mocked(mockHttp.request).mockResolvedValueOnce(mockResponse);

    const textToImage = new TextToImage(mockHttp);
    const result = await textToImage.get('task-123');

    expect(mockHttp.request).toHaveBeenCalledWith('GET', '/api/v1/seedream/text_to_image/task-123', {});
    expect(result).toEqual(mockResponse);
  });

  it('should create and poll until completion', async () => {
    const createResponse: TaskCreateResponse = { id: 'task-123' };
    const processingResponse: TextToImageResponse = { id: 'task-123', status: 'processing' };
    const completedResponse: TextToImageResponse = {
      id: 'task-123',
      status: 'completed',
      images: [{ url: 'https://file.runapi.ai/seedream/result.png' }],
    };

    vi.mocked(mockHttp.request)
      .mockResolvedValueOnce(createResponse)
      .mockResolvedValueOnce(processingResponse)
      .mockResolvedValueOnce(completedResponse);

    const textToImage = new TextToImage(mockHttp);
    const result = await textToImage.run({
      model: 'seedream-5-lite-text-to-image',
      prompt: 'A neon city',
      aspect_ratio: '4:3',
      output_quality: 'basic',
    });

    expect(result.status).toBe('completed');
    expect(result.images?.[0].url).toBe('https://file.runapi.ai/seedream/result.png');
  });

});
