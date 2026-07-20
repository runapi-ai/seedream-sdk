# Seedream Java SDK for RunAPI

[![Maven Central](https://img.shields.io/maven-central/v/ai.runapi/runapi-seedream)](https://central.sonatype.com/artifact/ai.runapi/runapi-seedream)

The Seedream Java SDK is the language-specific package for Seedream on RunAPI. Use it when your Java application needs typed builders, strict request validation, task status lookup, local polling helpers, file uploads, account helpers, and consistent RunAPI errors for Seedream workflows.

This README is the Java package guide inside the public `seedream-sdk` repository. For the repository overview, start at `../README.md`; for model details, use https://runapi.ai/models/seedream; for API reference, use https://runapi.ai/docs#seedream; for SDK docs, use https://runapi.ai/docs#sdk-seedream.

## Requirements

The Java SDK targets Java 8 bytecode and is tested on Java 8, 11, 17, and 21.

## Install

Gradle:

```kotlin
dependencies {
  implementation("ai.runapi:runapi-seedream:0.1.2")
}
```

Maven:

```xml
<dependency>
  <groupId>ai.runapi</groupId>
  <artifactId>runapi-seedream</artifactId>
  <version>0.1.2</version>
</dependency>
```

Use the BOM when multiple RunAPI Java modules are installed:

```kotlin
dependencies {
  implementation(platform("ai.runapi:runapi-bom:0.2.0"))
  implementation("ai.runapi:runapi-seedream")
}
```

Maven BOM:

```xml
<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>ai.runapi</groupId>
      <artifactId>runapi-bom</artifactId>
      <version>0.2.0</version>
      <type>pom</type>
      <scope>import</scope>
    </dependency>
  </dependencies>
</dependencyManagement>
```

## Quick Start

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

The client builder reads `RUNAPI_API_KEY` when `.apiKey(...)` is omitted. Set `RUNAPI_BASE_URL` or `.baseUrl(...)` only when using a non-default RunAPI endpoint.

## Seedream 5 Pro

Use `TextToImageModel.SEEDREAM_5_PRO_TEXT_TO_IMAGE` for generation and `EditImageModel.SEEDREAM_5_PRO_EDIT` for image editing. Both accept output quality, optional output format, and optional content safety checking; editing accepts up to 10 source image URLs.

## Task Lifecycle

Most media endpoints are asynchronous. `create(params)` submits a task and returns its id, `get(id)` fetches the latest task state, and `run(params)` creates the task and polls until it reaches a terminal state. Synchronous resources expose `run(params)` only.

```java
import ai.runapi.core.polling.TaskCreateResponse;
import ai.runapi.seedream.SeedreamClient;
import ai.runapi.seedream.types.TextToImageParams;
import ai.runapi.seedream.types.TextToImageResponse;
import ai.runapi.seedream.types.TextToImageModel;

SeedreamClient client = SeedreamClient.builder()
    .apiKey(System.getenv("RUNAPI_API_KEY"))
    .build();

TextToImageParams params = TextToImageParams.builder()
    .model(TextToImageModel.SEEDREAM_4_5_TEXT_TO_IMAGE)
    .aspectRatio("16:9")
    .outputQuality("basic")
    .prompt("A precise product render of a glass teapot on white marble")
    .outputResolution("720p")
    .build();

TaskCreateResponse task = client.textToImage().create(params);
TextToImageResponse status = client.textToImage().get(task.getId());
```

## Files

Each model package depends transitively on `ai.runapi:runapi-core`, so you can upload files through any model client.

```java
import ai.runapi.core.files.FileCreateParams;
import ai.runapi.core.files.FileUploadResponse;
import java.nio.file.Paths;

FileUploadResponse uploaded = client.files().create(
    FileCreateParams.fromPath(Paths.get("input.png"))
        .fileName("input.png")
        .build()
);
```

URL and base64 sources use the same entry point:

```java
FileUploadResponse fromUrl = client.files().create(
    FileCreateParams.fromUrl("https://cdn.runapi.ai/public/samples/input.png")
        .fileName("input.png")
        .build()
);

FileUploadResponse fromBase64 = client.files().create(
    FileCreateParams.fromBase64("iVBORw0KGgo...")
        .fileName("input.png")
        .build()
);
```

RunAPI-generated file URLs are temporary. Download and store generated images, videos, audio, or other files in your own durable storage within 7 days; do not treat returned URLs as long-term assets.

## Request Options

```java
import ai.runapi.core.RequestOptions;
import java.time.Duration;

RequestOptions options = RequestOptions.builder()
    .pollingInterval(Duration.ofSeconds(3))
    .pollingMaxWait(Duration.ofMinutes(20))
    .maxRetries(0)
    .build();
```

Per-request options can override timeout, retries, headers, and polling behavior.

## Error Handling

All SDK errors extend `RunApiException`.

```java
import ai.runapi.core.errors.RateLimitException;
import ai.runapi.core.errors.RunApiException;
import ai.runapi.core.errors.ValidationException;

try {
  client.textToImage().run(params);
} catch (ValidationException error) {
  System.err.println(error.getMessage());
} catch (RateLimitException error) {
  System.err.println(error.getRetryAfter());
} catch (RunApiException error) {
  System.err.println(error.getCode() + " " + error.getStatusCode());
}
```

## Links

- Model page: https://runapi.ai/models/seedream
- SDK docs: https://runapi.ai/docs#sdk-seedream
- Product docs: https://runapi.ai/docs#seedream
- Pricing and rate limits: https://runapi.ai/models/seedream/4.5-text-to-image
- Full catalog: https://runapi.ai/models
- Repository: https://github.com/runapi-ai/seedream-sdk

## License

Licensed under the Apache License, Version 2.0.
