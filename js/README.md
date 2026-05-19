# Seedream API JavaScript SDK for RunAPI

The seedream api JavaScript SDK is the language-specific package for Seedream on RunAPI. Use this seedream api package for text-to-image, image-to-image, edit, and creative production flows when your application needs JSON request bodies, task status lookup, and consistent RunAPI errors in JavaScript.

This seedream api README is the JavaScript package guide inside the public `seedream-sdk` repository. For the repository overview, start at `../README.md`; for model details, use https://runapi.ai/models/seedream; for API reference, use https://runapi.ai/docs#seedream; for SDK docs, use https://runapi.ai/docs#sdk-seedream.

## Install

```bash
npm install @runapi.ai/seedream
```

## Quick start

```typescript
import { SeedreamClient } from '@runapi.ai/seedream';

const client = new SeedreamClient();
const task = await client.generations.create({
  // Pass the Seedream JSON request body from https://runapi.ai/docs#seedream.
});
const status = await client.generations.get(task.id);
```

Use `create` when you want to submit a task and return quickly, `get` when you need the latest task state, and `run` when a script should create and poll until completion. In web request handlers, prefer `create` plus webhook or later `get` polling so a worker is not held open.

## Language notes

Use the TypeScript types in `src/types.ts` and the resource classes under `src/resources` when building image applications. The available resources include generations. Keep `RUNAPI_API_KEY` in the environment or your secret manager; never commit API keys or callback secrets.

## Links

- Model page: https://runapi.ai/models/seedream
- SDK docs: https://runapi.ai/docs#sdk-seedream
- Product docs: https://runapi.ai/docs#seedream
- Pricing and rate limits: https://runapi.ai/models/seedream/4.5-text-to-image
- Provider comparison: https://runapi.ai/providers/bytedance
- Full catalog: https://runapi.ai/models
- Repository: https://github.com/runapi-ai/seedream-sdk

## License

Licensed under the Apache License, Version 2.0.
