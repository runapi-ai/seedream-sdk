<p align="center">
  <a href="https://runapi.ai"><img src="https://runapi.ai/icon.svg" height="56" alt="RunAPI"></a>
</p>

<h3 align="center">
  <a href="https://github.com/runapi-ai/seedream-sdk">Seedream API SDK for RunAPI</a>
</h3>

<p align="center">
  Seedream API SDKs for JavaScript, Ruby, and Go on RunAPI.
</p>

<div align="center">

[![npm](https://img.shields.io/npm/v/@runapi.ai/seedream)](https://www.npmjs.com/package/@runapi.ai/seedream)
[![RubyGems](https://img.shields.io/gem/v/runapi-seedream)](https://rubygems.org/gems/runapi-seedream)
[![Go Reference](https://pkg.go.dev/badge/github.com/runapi-ai/seedream-sdk/go.svg)](https://pkg.go.dev/github.com/runapi-ai/seedream-sdk/go)
[![License](https://img.shields.io/github/license/runapi-ai/seedream-sdk)](https://github.com/runapi-ai/seedream-sdk/blob/main/LICENSE)

</div>
<br/>

The seedream api SDK packages JavaScript, Ruby, and Go clients for Seedream on RunAPI. Use this seedream api SDK for text-to-image and image-to-image generation workflows that need typed installs, JSON request bodies, task polling, and consistent RunAPI errors across services.

Seedream belongs to the Bytedance catalog on RunAPI. The public model page is https://runapi.ai/models/seedream; variant pages below carry pricing, rate-limit, and commercial-usage details. The public `seedream-sdk` repository groups the JavaScript, Ruby, and Go packages for this model.

## Install

```bash
npm install @runapi.ai/seedream
gem install runapi-seedream
go get github.com/runapi-ai/seedream-sdk/go@latest
```

## What you can build

- Build creative tools, agent pipelines, and production integrations with the seedream api SDK.
- Keep one model-specific repository while installing only the language package your app needs.
- Use `create` for submit-only jobs, `get` for status lookup, and `run` for submit-and-poll scripts.
- Handle authentication, validation, rate limits, insufficient credits, task failures, and polling timeouts through RunAPI SDK errors.

The JavaScript client exposes text to image resources, and the Ruby and Go packages mirror the same RunAPI task lifecycle.

## JavaScript quick start

```typescript
import { SeedreamClient } from '@runapi.ai/seedream';

const client = new SeedreamClient();

const task = await client.textToImage.create({
  // Pass the Seedream request body documented at https://runapi.ai/docs#seedream.
});

const status = await client.textToImage.get(task.id);
```

For short scripts, use `run` with the same JSON body to create the task and wait for completion. For web request handlers, prefer `create` plus webhook or later `get` polling so the server does not hold a worker open.

## Repository layout

- `js/` publishes `@runapi.ai/seedream`.
- `ruby/` publishes `runapi-seedream` when RubyGems publishing resumes.
- `go/` publishes `github.com/runapi-ai/seedream-sdk/go` and depends on `github.com/runapi-ai/core-sdk/go`.

## Public links

- Model page: https://runapi.ai/models/seedream
- SDK docs: https://runapi.ai/docs#sdk-seedream
- Product docs: https://runapi.ai/docs#seedream
- SDK repository: https://github.com/runapi-ai/seedream-sdk
- Skill repository: https://github.com/runapi-ai/seedream
- Provider comparison: https://runapi.ai/providers/bytedance
- Full catalog: https://runapi.ai/models

## Pricing and variants

Use the most specific seedream api variant page for pricing, rate limits, and commercial usage:
- [4.5 text to image](https://runapi.ai/models/seedream/4.5-text-to-image)
- [4.5 edit](https://runapi.ai/models/seedream/4.5-edit)
- [5 lite text to image](https://runapi.ai/models/seedream/5-lite-text-to-image)
- [5 lite image to image](https://runapi.ai/models/seedream/5-lite-image-to-image)

Default pricing link for the seedream api SDK: https://runapi.ai/models/seedream/4.5-text-to-image

## FAQ

### Which package should I install for seedream api work?

Install the model package for your language: `@runapi.ai/seedream`, `runapi-seedream`, or `github.com/runapi-ai/seedream-sdk/go`. Install core SDK packages only when you are building shared SDK infrastructure.

### Where should public links point?

Primary seedream api links point to https://runapi.ai/models/seedream. Pricing and usage-policy links point to variant pages such as https://runapi.ai/models/seedream/4.5-text-to-image. Provider comparisons point to https://runapi.ai/providers/bytedance, and broad browsing points to https://runapi.ai/models.

## License

Licensed under the Apache License, Version 2.0.
