package seedream

// SeedreamModel constrains the model parameter to valid Seedream variants.
type SeedreamModel string

// AspectRatio constrains the output aspect ratio to accepted values.
type AspectRatio string

// OutputQuality constrains the quality preset for Seedream 4.5 and 5-lite models.
type OutputQuality string

// V4OutputResolution constrains the output resolution tier for Seedream V4 models.
type V4OutputResolution string

// TaskStatus represents the lifecycle state of an async task.
type TaskStatus string

const (
	// Model45TextToImage is Seedream 4.5 text-to-image generation.
	Model45TextToImage SeedreamModel = "seedream-4.5-text-to-image"
	// Model45Edit is Seedream 4.5 image editing.
	Model45Edit SeedreamModel = "seedream-4.5-edit"
	// Model5LiteT2I is Seedream 5 Lite text-to-image, a lightweight faster variant.
	Model5LiteT2I SeedreamModel = "seedream-5-lite-text-to-image"
	// Model5LiteEdit is Seedream 5 Lite image editing.
	Model5LiteEdit SeedreamModel = "seedream-5-lite-edit"
	// ModelV4TextToImage is Seedream V4 text-to-image with seed and multi-output support.
	ModelV4TextToImage SeedreamModel = "seedream-v4-text-to-image"
	// ModelV4Edit is Seedream V4 image editing with seed and multi-output support.
	ModelV4Edit SeedreamModel = "seedream-v4-edit"
)

// TextToImageParams configures a generation request. AspectRatio and OutputQuality
// are required for 4.5 and 5-lite models but optional for V4, which uses
// OutputResolution instead.
type TextToImageParams struct {
	Model               SeedreamModel      `json:"model" help:"required; model slug"`
	Prompt              string             `json:"prompt" help:"required; 4.5 models allow 1-3000 chars, 5-lite models allow 3-3000 chars, v4 models allow 1-5000 chars"`
	AspectRatio         AspectRatio        `json:"aspect_ratio,omitempty" help:"required for 4.5/5-lite; optional for v4; output aspect ratio"`
	OutputQuality       OutputQuality      `json:"output_quality" help:"required for 4.5/5-lite only; output quality preset"`
	OutputResolution    V4OutputResolution `json:"output_resolution,omitempty" help:"optional for v4; output resolution tier. Default: 1k"`
	OutputCount         *int               `json:"output_count,omitempty" help:"optional for v4; number of generated images. Default: 1"`
	Seed                *int               `json:"seed,omitempty" help:"optional for v4; integer seed for reproducibility"`
	EnableSafetyChecker *bool              `json:"enable_safety_checker,omitempty" help:"optional; content safety check toggle"`
	CallbackURL         string             `json:"callback_url,omitempty" help:"optional; webhook URL"`
}

// EditImageParams configures an editing request. The same model-dependent field
// requirements as TextToImageParams apply, plus SourceImageURLs is required.
type EditImageParams struct {
	Model               SeedreamModel      `json:"model" help:"required; model slug"`
	Prompt              string             `json:"prompt" help:"required; 4.5 models allow 1-3000 chars, 5-lite models allow 3-3000 chars, v4 models allow 1-5000 chars"`
	AspectRatio         AspectRatio        `json:"aspect_ratio,omitempty" help:"required for 4.5/5-lite; optional for v4; output aspect ratio"`
	OutputQuality       OutputQuality      `json:"output_quality" help:"required for 4.5/5-lite only; output quality preset"`
	SourceImageURLs     []string           `json:"source_image_urls" help:"required; source image URLs. v4 edit allows up to 10 URLs, 4.5 and 5-lite edit allow up to 14"`
	OutputResolution    V4OutputResolution `json:"output_resolution,omitempty" help:"optional for v4; output resolution tier. Default: 1k"`
	OutputCount         *int               `json:"output_count,omitempty" help:"optional for v4; number of generated images. Default: 1"`
	Seed                *int               `json:"seed,omitempty" help:"optional for v4; integer seed for reproducibility"`
	EnableSafetyChecker *bool              `json:"enable_safety_checker,omitempty" help:"optional; content safety check toggle"`
	CallbackURL         string             `json:"callback_url,omitempty" help:"optional; webhook URL"`
}

// AsyncTaskResponse implements core.TaskResponse for async task polling.
type AsyncTaskResponse struct {
	ID     string     `json:"id"`
	Status TaskStatus `json:"status"`
	Error  string     `json:"error,omitempty"`
}

func (r AsyncTaskResponse) GetID() string     { return r.ID }
func (r AsyncTaskResponse) GetStatus() string { return string(r.Status) }
func (r AsyncTaskResponse) GetError() string  { return r.Error }

// Image holds a CDN URL for a generated image.
type Image struct {
	URL string `json:"url"`
}

// TextToImageResponse contains the generated images from a text-to-image task.
type TextToImageResponse struct {
	AsyncTaskResponse
	Images []Image `json:"images,omitempty"`
}

// EditImageResponse is an alias for TextToImageResponse since edits return the same shape.
type EditImageResponse = TextToImageResponse
