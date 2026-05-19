import { describe, it, expect, vi, beforeEach } from 'vitest';
import { TextToImage } from '../../src/resources/text-to-image';
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
      quality: 'basic',
    });

    expect(mockHttp.request).toHaveBeenCalledWith('POST', '/api/v1/seedream/text_to_image', {
      body: {
        model: 'seedream-4.5-text-to-image',
        prompt: 'A beautiful landscape',
        aspect_ratio: '16:9',
        quality: 'basic',
      },
    });
    expect(result).toEqual(mockResponse);
  });

  it('should send correct request for 5-lite image-to-image', async () => {
    const mockResponse: TaskCreateResponse = { id: 'task-456' };
    vi.mocked(mockHttp.request).mockResolvedValueOnce(mockResponse);

    const textToImage = new TextToImage(mockHttp);
    await textToImage.create({
      model: 'seedream-5-lite-image-to-image',
      prompt: 'Restyle this image',
      image_urls: ['https://example.com/input.png'],
      aspect_ratio: '1:1',
      quality: 'high',
      nsfw_checker: false,
    });

    expect(mockHttp.request).toHaveBeenCalledWith('POST', '/api/v1/seedream/text_to_image', {
      body: {
        model: 'seedream-5-lite-image-to-image',
        prompt: 'Restyle this image',
        image_urls: ['https://example.com/input.png'],
        aspect_ratio: '1:1',
        quality: 'high',
        nsfw_checker: false,
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
      images: [{ url: 'https://example.com/result.png' }],
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
      quality: 'basic',
    });

    expect(result.status).toBe('completed');
    expect(result.images?.[0].url).toBe('https://example.com/result.png');
  });
});
