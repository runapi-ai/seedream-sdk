# Seedream API Ruby SDK for RunAPI

The seedream api Ruby SDK is the language-specific package for Seedream on RunAPI. Use this seedream api package for text-to-image, image editing, and creative production flows when your application needs JSON request bodies, task status lookup, and consistent RunAPI errors in Ruby.

This seedream api README is the Ruby package guide inside the public `seedream-sdk` repository. For the repository overview, start at `../README.md`; for model details, use https://runapi.ai/models/seedream; for API reference, use https://runapi.ai/docs#seedream; for SDK docs, use https://runapi.ai/docs#sdk-seedream.

## Install

```bash
gem install runapi-seedream
```

## Quick start

```ruby
require "runapi-seedream"

client = RunApi::Seedream::Client.new
task = client.text_to_image.create(
  model: "seedream-v4-text-to-image",
  prompt: "A precise product render of a glass teapot on white marble",
  aspect_ratio: "16:9",
  output_resolution: "2k",
  output_count: 3
)
status = client.text_to_image.get(task.id)
```

Use `create` when you want to submit a task and return quickly, `get` when you need the latest task state, and `run` when a script should create and poll until completion. In web request handlers, prefer `create` plus webhook or later `get` polling so a worker is not held open.

RunAPI-generated file URLs are temporary. Download and store generated images, videos, audio, or other files in your own durable storage within 7 days; do not treat returned URLs as long-term assets.

## Language notes

Use Ruby keyword arguments and the `RunApi::Seedream` error classes when building image jobs, Rails workers, or scripts. The package exposes `text_to_image` for text models and `edit_image` for editing models. Keep `RUNAPI_API_KEY` in the environment or your secret manager; never commit API keys or callback secrets.

## Links

- Model page: https://runapi.ai/models/seedream
- SDK docs: https://runapi.ai/docs#sdk-seedream
- Product docs: https://runapi.ai/docs#seedream
- Pricing and rate limits: https://runapi.ai/models/seedream/v4-text-to-image
- Full catalog: https://runapi.ai/models
- Repository: https://github.com/runapi-ai/seedream-sdk

## License

Licensed under the Apache License, Version 2.0.
