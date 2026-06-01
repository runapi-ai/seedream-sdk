# Seedream API Go SDK for RunAPI

The seedream api Go SDK is the language-specific package for Seedream on RunAPI. Use this seedream api package for text-to-image, image editing, and creative production flows when your application needs JSON request bodies, task status lookup, and consistent RunAPI errors in Go.

This seedream api README is the Go package guide inside the public `seedream-sdk` repository. For the repository overview, start at `../README.md`; for model details, use https://runapi.ai/models/seedream; for API reference, use https://runapi.ai/docs#seedream; for SDK docs, use https://runapi.ai/docs#sdk-seedream.

## Install

```bash
go get github.com/runapi-ai/seedream-sdk/go@latest
```

## Quick start

```go
import (
  "context"

  "github.com/runapi-ai/seedream-sdk/go/seedream"
)

client, err := seedream.NewClient()
outputCount := 3
task, err := client.TextToImage.Create(context.Background(), seedream.TextToImageParams{
  Model: seedream.ModelV4TextToImage,
  Prompt: "A precise product render of a glass teapot on white marble",
  AspectRatio: "16:9",
  OutputResolution: "2k",
  OutputCount: &outputCount,
})
status, err := client.TextToImage.Get(context.Background(), task.ID)
```

Use `create` when you want to submit a task and return quickly, `get` when you need the latest task state, and `run` when a script should create and poll until completion. In web request handlers, prefer `create` plus webhook or later `get` polling so a worker is not held open.

## Language notes

Use the public Go module with `github.com/runapi-ai/core-sdk/go` options when building image services, CLIs, or workers. The package exposes `TextToImage` for text models and `EditImage` for editing models. Keep `RUNAPI_API_KEY` in the environment or your secret manager; never commit API keys or callback secrets.

## Links

- Model page: https://runapi.ai/models/seedream
- SDK docs: https://runapi.ai/docs#sdk-seedream
- Product docs: https://runapi.ai/docs#seedream
- Pricing and rate limits: https://runapi.ai/models/seedream/v4-text-to-image
- Full catalog: https://runapi.ai/models
- Repository: https://github.com/runapi-ai/seedream-sdk

## License

Licensed under the Apache License, Version 2.0.
