// Package seedream provides the Seedream image generation API client.
//
//	client, err := seedream.NewClient(option.WithAPIKey("sk-your-api-key"))
//	result, err := client.TextToImage.Run(ctx, seedream.TextToImageParams{
//	    Model: seedream.ModelV4TextToImage, Prompt: "A beautiful product render", AspectRatio: "16:9",
//	})
package seedream

import (
	"context"

	"github.com/runapi-ai/core-sdk/go/base"
	"github.com/runapi-ai/core-sdk/go/core"
	"github.com/runapi-ai/core-sdk/go/option"
)

const (
	textToImagePath     = "/api/v1/seedream/text_to_image"
	editImagePath       = "/api/v1/seedream/edit_image"
	decomposeLayersPath = "/api/v1/seedream/decompose_layers"
)

// Client is the Seedream image generation API client.
type Client struct {
	base.Base
	// TextToImage provides text-to-image generation operations.
	TextToImage *TextToImage
	// EditImage provides image editing operations using source images.
	EditImage *EditImage
	// DecomposeLayers separates an image into a base image and independent layers.
	DecomposeLayers *DecomposeLayers
}

// NewClient creates a Seedream client with the given options.
func NewClient(opts ...option.ClientOption) (*Client, error) {
	resolved, err := option.ResolveClientOptions(opts...)
	if err != nil {
		return nil, err
	}
	httpClient, err := core.NewHTTPClient(resolved)
	if err != nil {
		return nil, err
	}
	return NewClientWithHTTP(httpClient), nil
}

// NewClientWithHTTP creates a Seedream client with a pre-configured HTTP transport.
func NewClientWithHTTP(httpClient core.HTTPClient) *Client {
	return &Client{
		Base:            base.New(httpClient),
		TextToImage:     &TextToImage{http: httpClient},
		EditImage:       &EditImage{http: httpClient},
		DecomposeLayers: &DecomposeLayers{http: httpClient},
	}
}

// TextToImage generates images from text prompts across Seedream model versions.
type TextToImage struct{ http core.HTTPClient }

// EditImage modifies source images according to a text prompt.
type EditImage struct{ http core.HTTPClient }

// DecomposeLayers separates one image into a base image and independent layers.
type DecomposeLayers struct{ http core.HTTPClient }

// Create submits a text-to-image task and returns immediately with a task id.
func (r *TextToImage) Create(ctx context.Context, params TextToImageParams, opts ...option.RequestOption) (*core.TaskCreateResponse, error) {
	requestOptions, _ := option.ResolveRequestOptions(opts...)
	body := core.CompactParams(params)
	if err := core.ValidateParams(contractSchema["text-to-image"], body); err != nil {
		return nil, err
	}
	return core.PostJSON[core.TaskCreateResponse](ctx, r.http, textToImagePath, body, requestOptions)
}

// Get fetches the current status of a text-to-image task by id.
func (r *TextToImage) Get(ctx context.Context, id string, opts ...option.RequestOption) (*TextToImageResponse, error) {
	requestOptions, _ := option.ResolveRequestOptions(opts...)
	return core.GetJSON[TextToImageResponse](ctx, r.http, core.ResourcePath(textToImagePath, id), requestOptions)
}

// Run submits a text-to-image task and polls until it completes.
func (r *TextToImage) Run(ctx context.Context, params TextToImageParams, opts ...option.RequestOption) (*TextToImageResponse, error) {
	_, pollingOptions := option.ResolveRequestOptions(opts...)
	return core.RunAsync(ctx, func(ctx context.Context) (*core.TaskCreateResponse, error) { return r.Create(ctx, params, opts...) }, func(ctx context.Context, id string) (*TextToImageResponse, error) { return r.Get(ctx, id, opts...) }, pollingOptions)
}

// Create submits an image-editing task and returns immediately with a task id.
func (r *EditImage) Create(ctx context.Context, params EditImageParams, opts ...option.RequestOption) (*core.TaskCreateResponse, error) {
	requestOptions, _ := option.ResolveRequestOptions(opts...)
	body := core.CompactParams(params)
	if err := core.ValidateParams(contractSchema["edit-image"], body); err != nil {
		return nil, err
	}
	return core.PostJSON[core.TaskCreateResponse](ctx, r.http, editImagePath, body, requestOptions)
}

// Get fetches the current status of an image-editing task by id.
func (r *EditImage) Get(ctx context.Context, id string, opts ...option.RequestOption) (*EditImageResponse, error) {
	requestOptions, _ := option.ResolveRequestOptions(opts...)
	return core.GetJSON[EditImageResponse](ctx, r.http, core.ResourcePath(editImagePath, id), requestOptions)
}

// Run submits an image-editing task and polls until it completes.
func (r *EditImage) Run(ctx context.Context, params EditImageParams, opts ...option.RequestOption) (*EditImageResponse, error) {
	_, pollingOptions := option.ResolveRequestOptions(opts...)
	return core.RunAsync(ctx, func(ctx context.Context) (*core.TaskCreateResponse, error) { return r.Create(ctx, params, opts...) }, func(ctx context.Context, id string) (*EditImageResponse, error) { return r.Get(ctx, id, opts...) }, pollingOptions)
}

// Create submits a layer decomposition task and returns immediately with a task id.
func (r *DecomposeLayers) Create(ctx context.Context, params DecomposeLayersParams, opts ...option.RequestOption) (*core.TaskCreateResponse, error) {
	requestOptions, _ := option.ResolveRequestOptions(opts...)
	body := core.CompactParams(params)
	if err := core.ValidateParams(contractSchema["decompose-layers"], body); err != nil {
		return nil, err
	}
	return core.PostJSON[core.TaskCreateResponse](ctx, r.http, decomposeLayersPath, body, requestOptions)
}

// Get fetches the current status of a layer decomposition task by id.
func (r *DecomposeLayers) Get(ctx context.Context, id string, opts ...option.RequestOption) (*DecomposeLayersResponse, error) {
	requestOptions, _ := option.ResolveRequestOptions(opts...)
	return core.GetJSON[DecomposeLayersResponse](ctx, r.http, core.ResourcePath(decomposeLayersPath, id), requestOptions)
}

// Run submits a layer decomposition task and polls until it completes.
func (r *DecomposeLayers) Run(ctx context.Context, params DecomposeLayersParams, opts ...option.RequestOption) (*DecomposeLayersResponse, error) {
	_, pollingOptions := option.ResolveRequestOptions(opts...)
	return core.RunAsync(ctx, func(ctx context.Context) (*core.TaskCreateResponse, error) { return r.Create(ctx, params, opts...) }, func(ctx context.Context, id string) (*DecomposeLayersResponse, error) { return r.Get(ctx, id, opts...) }, pollingOptions)
}
