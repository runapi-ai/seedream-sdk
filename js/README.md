# Seedream JavaScript SDK for RunAPI

The Seedream JavaScript SDK is the language-specific package for Seedream on RunAPI. Use this package for image generation, image editing, and creative production workflows when your application needs request bodies, task status lookup, and consistent RunAPI errors in JavaScript.

This README is the JavaScript package guide inside the public `seedream-sdk` repository. For the repository overview, start at `../README.md`; for model details, use https://runapi.ai/models/seedream; for API reference, use https://runapi.ai/docs/api/seedream/text-to-image; for SDK docs, use https://runapi.ai/docs/resources/sdks.

## Install

```bash
npm install @runapi.ai/seedream
```

## Quick start

```typescript
import { SeedreamClient } from '@runapi.ai/seedream';

const client = new SeedreamClient();
const task = await client.textToImage.create({
  model: 'seedream-v4-text-to-image',
  prompt: 'A precise product render of a glass teapot on white marble',
  aspect_ratio: '16:9',
  output_resolution: '2k',
  output_count: 3,
});
const status = await client.textToImage.get(task.id);
```

Use `create` when you want to submit a task and return quickly, `get` when you need the latest task state, and `run` when a script should create and poll until completion. In web request handlers, prefer `create` plus webhook or later `get` polling so a worker is not held open.

RunAPI-generated file URLs are temporary. Download and store generated images, videos, audio, or other files in your own durable storage within 7 days; do not treat returned URLs as long-term assets.

## Seedream 5 Pro

Use `seedream-5-pro-text-to-image` for generation, `seedream-5-pro-edit` for image editing, and `seedream-5-pro-layer-decomposition` to separate one image into a base image and ordered transparent layers.

## Language notes

Use the TypeScript types in `src/types.ts` and the resource classes under `src/resources` when building image applications. The package exposes `textToImage`, `editImage`, and `decomposeLayers`. Keep `RUNAPI_API_KEY` in the environment or your secret manager; never commit API keys or callback secrets.

## Links

- Model page: https://runapi.ai/models/seedream
- SDK docs: https://runapi.ai/docs/resources/sdks
- Product docs: https://runapi.ai/docs/api/seedream/text-to-image
- Pricing and rate limits: https://runapi.ai/models/seedream/v4-text-to-image
- Full catalog: https://runapi.ai/models
- Repository: https://github.com/runapi-ai/seedream-sdk

## License

Licensed under the Apache License, Version 2.0.
