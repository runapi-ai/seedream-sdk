package seedream

type SeedreamModel string

type AspectRatio string

type Quality string

type TaskStatus string

const (
	Model45TextToImage SeedreamModel = "seedream-4.5-text-to-image"
	Model45Edit        SeedreamModel = "seedream-4.5-edit"
	Model5LiteT2I      SeedreamModel = "seedream-5-lite-text-to-image"
	Model5LiteI2I      SeedreamModel = "seedream-5-lite-image-to-image"
)

type TextToImageParams struct {
	Model       SeedreamModel `json:"model" help:"required; seedream-4.5-text-to-image, seedream-4.5-edit, seedream-5-lite-text-to-image, or seedream-5-lite-image-to-image"`
	Prompt      string        `json:"prompt" help:"required; 4.5 models allow 1-3000 chars, 5-lite models allow 3-3000 chars"`
	AspectRatio AspectRatio   `json:"aspect_ratio" help:"required; 1:1, 4:3, 3:4, 16:9, 9:16, 2:3, 3:2, 21:9"`
	Quality     Quality       `json:"quality" help:"required; basic or high"`
	ImageURLs   []string      `json:"image_urls,omitempty" help:"required for edit/image-to-image models; up to 14 source image URLs"`
	NsfwChecker *bool         `json:"nsfw_checker,omitempty" help:"optional; 5-lite models only. Default: false"`
	CallbackURL string        `json:"callback_url,omitempty" help:"optional; webhook URL"`
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
