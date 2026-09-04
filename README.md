<p align="center">
  <a href="https://runapi.ai"><img src="https://runapi.ai/icon.svg" height="56" alt="RunAPI"></a>
</p>

<h3 align="center">
  <a href="https://github.com/runapi-ai/seedream-sdk">Seedream API SDK for RunAPI</a>
</h3>

<p align="center">
  Seedream API SDKs for JavaScript, Python, Ruby, Go, Java, and PHP on RunAPI.
</p>

<div align="center">

[![npm](https://img.shields.io/npm/v/@runapi.ai/seedream)](https://www.npmjs.com/package/@runapi.ai/seedream)
[![PyPI](https://img.shields.io/pypi/v/runapi-seedream)](https://pypi.org/project/runapi-seedream/)
[![RubyGems](https://img.shields.io/gem/v/runapi-seedream)](https://rubygems.org/gems/runapi-seedream)
[![Go Reference](https://pkg.go.dev/badge/github.com/runapi-ai/seedream-sdk/go.svg)](https://pkg.go.dev/github.com/runapi-ai/seedream-sdk/go)
[![Maven Central](https://img.shields.io/maven-central/v/ai.runapi/runapi-seedream)](https://central.sonatype.com/artifact/ai.runapi/runapi-seedream)
[![License](https://img.shields.io/github/license/runapi-ai/seedream-sdk)](https://github.com/runapi-ai/seedream-sdk/blob/main/LICENSE)

</div>
<br/>

The Seedream API SDK packages JavaScript, Python, Ruby, Go, Java, and PHP clients for Seedream on RunAPI. Use it for text-to-image and edit-image workflows when your app needs typed request builders, predictable task polling, file upload helpers, account helpers, and consistent RunAPI errors.

Seedream is listed in the RunAPI model catalog at https://runapi.ai/models/seedream. Variant pages below carry pricing, rate-limit, and commercial-usage details. The public `seedream-sdk` repository groups the non-PHP language packages, examples, CI, and release tags for this model. The PHP package is released from a split Composer repository.

## Install

```bash
npm install @runapi.ai/seedream
pip install runapi-seedream
gem install runapi-seedream
go get github.com/runapi-ai/seedream-sdk/go@latest
```

Gradle:

```kotlin
dependencies {
  implementation("ai.runapi:runapi-seedream:0.2.0")
}
```

Maven:

```xml
<dependency>
  <groupId>ai.runapi</groupId>
  <artifactId>runapi-seedream</artifactId>
  <version>0.2.0</version>
</dependency>
```

Use the Java BOM when installing multiple RunAPI Java modules:

```kotlin
dependencies {
  implementation(platform("ai.runapi:runapi-bom:0.6.2"))
  implementation("ai.runapi:runapi-seedream")
}
```

The PHP package is published from the split Composer repository as `runapi-ai/seedream`; see https://github.com/runapi-ai/seedream-php for PHP install and examples.

## What you can build

- Build apps, agent workflows, batch jobs, and production services around Seedream requests.
- Install only the language package your app needs while keeping one model-specific repository for docs and releases.
- Use `create` for submit-only jobs, `get` for status lookup, and `run` for submit-and-poll scripts.
- Upload local files, URL files, or base64 files through shared RunAPI file helpers.
- Handle validation, authentication, rate limits, insufficient credits, task failures, and polling timeouts through RunAPI SDK errors.

## Seedream 5-Lite output format

Both 5-Lite endpoints accept optional `output_format`: `png` (default) or `jpeg`.

```typescript
import { SeedreamClient } from '@runapi.ai/seedream';

const client = new SeedreamClient();
const task = await client.textToImage.create({
  model: 'seedream-5-lite-text-to-image',
  prompt: 'A bright editorial photo of a modern bookstore cafe',
  aspect_ratio: '4:3',
  output_quality: 'basic',
  output_format: 'jpeg',
});
```

## Seedream 5 Pro

Seedream 5 Pro supports high-quality text-to-image and edit-image workflows with 1K or 2K output selected through `output_quality`. The `decomposeLayers` resource separates one source image into a base image and ordered transparent layers with `seedream-5-pro-layer-decomposition`.

```typescript
const result = await client.editImage.run({
  model: 'seedream-5-pro-edit',
  prompt: 'Turn the material into transparent glass',
  source_image_urls: ['https://cdn.runapi.ai/public/samples/image.jpg'],
  aspect_ratio: '3:2',
  output_quality: 'high',
  output_format: 'png',
});
```

## Java quick start

```java
import ai.runapi.seedream.SeedreamClient;
import ai.runapi.seedream.types.TextToImageParams;
import ai.runapi.seedream.types.CompletedTextToImageResponse;
import ai.runapi.seedream.types.TextToImageModel;

SeedreamClient client = SeedreamClient.builder()
    .apiKey(System.getenv("RUNAPI_API_KEY"))
    .build();

CompletedTextToImageResponse result = client.textToImage().run(
    TextToImageParams.builder()
        .model(TextToImageModel.SEEDREAM_4_5_TEXT_TO_IMAGE)
        .aspectRatio("16:9")
        .outputQuality("basic")
        .prompt("A precise product render of a glass teapot on white marble")
        .outputResolution("720p")
        .build()
);
```

Java packages target Java 8 bytecode and are tested on Java 8, 11, 17, and 21. Each model artifact depends on `ai.runapi:runapi-core`, so application code normally installs only `ai.runapi:runapi-seedream`.

## Task lifecycle

Most media endpoints are asynchronous. `create()` submits a task and returns its id, `get(id)` fetches the latest task state, and `run(params)` creates the task and polls until it reaches a terminal state. In web request handlers, prefer `create()` plus webhook or later `get()` polling so the server does not hold a worker open.

## Repository layout

- `js/` publishes `@runapi.ai/seedream`.
- `python/` publishes `runapi-seedream`.
- `ruby/` publishes `runapi-seedream`.
- `go/` publishes `github.com/runapi-ai/seedream-sdk/go`.
- `java/` publishes `ai.runapi:runapi-seedream` and uses `ai.runapi:runapi-core`.

## Public links

- Model page: https://runapi.ai/models/seedream
- SDK docs: https://runapi.ai/docs/resources/sdks
- Product docs: https://runapi.ai/docs/api/seedream/text-to-image
- SDK repository: https://github.com/runapi-ai/seedream-sdk
- PHP package repository: https://github.com/runapi-ai/seedream-php
- Skill repository: https://github.com/runapi-ai/seedream
- Provider comparison: https://runapi.ai/providers/bytedance
- Full catalog: https://runapi.ai/models

## Pricing and variants

Use the most specific Seedream variant page for pricing, rate limits, and commercial usage:
- [4.5 text to image](https://runapi.ai/models/seedream/4.5-text-to-image)
- [4.5 edit](https://runapi.ai/models/seedream/4.5-edit)
- [5 lite text to image](https://runapi.ai/models/seedream/5-lite-text-to-image)
- [5 lite edit](https://runapi.ai/models/seedream/5-lite-edit)
- [5 pro text to image](https://runapi.ai/models/seedream/5-pro-text-to-image)
- [5 pro edit](https://runapi.ai/models/seedream/5-pro-edit)
- [v4 text to image](https://runapi.ai/models/seedream/v4-text-to-image)
- [v4 edit](https://runapi.ai/models/seedream/v4-edit)

Default pricing link for the Seedream SDK: https://runapi.ai/models/seedream/4.5-text-to-image

## File storage

RunAPI-generated file URLs are temporary. Download and store generated images, videos, audio, or other files in your own durable storage within 7 days; do not treat returned URLs as long-term assets.

## FAQ

### Which package should I install for Seedream work?

Install the model package for your language: `@runapi.ai/seedream` on npm, `runapi-seedream` on PyPI, `runapi-seedream` on RubyGems, `github.com/runapi-ai/seedream-sdk/go`, `ai.runapi:runapi-seedream` on Maven Central, or `runapi-ai/seedream` on Packagist. Install core SDK packages only when you are building shared SDK infrastructure.

### Where should public links point?

Primary Seedream links point to https://runapi.ai/models/seedream. Pricing and usage-policy links point to variant pages such as https://runapi.ai/models/seedream/4.5-text-to-image. Provider comparisons point to https://runapi.ai/providers/bytedance, and broad browsing points to https://runapi.ai/models.

## License

Licensed under the Apache License, Version 2.0.
