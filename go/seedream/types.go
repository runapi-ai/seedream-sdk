package seedream

type SeedreamModel string

type AspectRatio string

type OutputQuality string

type V4OutputResolution string

type TaskStatus string

const (
	Model45TextToImage SeedreamModel = "seedream-4.5-text-to-image"
	Model45Edit        SeedreamModel = "seedream-4.5-edit"
	Model5LiteT2I      SeedreamModel = "seedream-5-lite-text-to-image"
	Model5LiteEdit     SeedreamModel = "seedream-5-lite-edit"
	ModelV4TextToImage SeedreamModel = "seedream-v4-text-to-image"
	ModelV4Edit        SeedreamModel = "seedream-v4-edit"
)

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

type AsyncTaskResponse struct {
	ID     string     `json:"id"`
	Status TaskStatus `json:"status"`
	Error  string     `json:"error,omitempty"`
}

func (r AsyncTaskResponse) GetID() string     { return r.ID }
func (r AsyncTaskResponse) GetStatus() string { return string(r.Status) }
func (r AsyncTaskResponse) GetError() string  { return r.Error }

type Image struct {
	URL string `json:"url"`
}

type TextToImageResponse struct {
	AsyncTaskResponse
	Images []Image `json:"images,omitempty"`
}

type EditImageResponse = TextToImageResponse
