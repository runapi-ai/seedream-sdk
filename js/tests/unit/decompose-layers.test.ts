import { describe, expect, it, vi } from 'vitest';
import { DecomposeLayers } from '../../src/resources/decompose-layers';

describe('DecomposeLayers', () => {
  it('creates and gets layer decomposition tasks', async () => {
    const http = { request: vi.fn().mockResolvedValue({ id: 'task-1', status: 'processing' }) } as any;
    const resource = new DecomposeLayers(http);
    http.request.mockResolvedValueOnce({ id: 'task-1', status: 'processing' }).mockResolvedValueOnce({
      id: 'task-1', status: 'completed', base_image: { url: 'https://file.runapi.ai/base.jpeg' },
      layers: [{ url: 'https://file.runapi.ai/layer.png', z_index: 1 }],
      usage: { cost: 0.05, generated_images: 2 },
    });

    await resource.create({
      model: 'seedream-5-pro-layer-decomposition',
      image_url: 'https://cdn.runapi.ai/public/samples/image.jpg',
      size: '1K',
      output_format: 'png',
    });
    const result = await resource.get('task-1');
    expect(result.usage?.generated_images).toBe(2);
    expect(result.base_image?.url).toBe('https://file.runapi.ai/base.jpeg');

    expect(http.request).toHaveBeenNthCalledWith(1, 'POST', '/api/v1/seedream/decompose_layers', {
      body: {
        model: 'seedream-5-pro-layer-decomposition',
        image_url: 'https://cdn.runapi.ai/public/samples/image.jpg',
        size: '1K',
        output_format: 'png',
      },
    });
    expect(http.request).toHaveBeenNthCalledWith(2, 'GET', '/api/v1/seedream/decompose_layers/task-1', {});
  });
});
