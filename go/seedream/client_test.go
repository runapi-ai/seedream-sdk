package seedream

import (
	"context"
	"encoding/json"
	"testing"

	"github.com/runapi-ai/core-sdk/go/core"
)

type stubHTTPClient struct {
	method string
	path   string
	body   any
}

func (s *stubHTTPClient) Request(_ context.Context, method, path string, opts *core.HTTPRequestOptions) (json.RawMessage, error) {
	s.method = method
	s.path = path
	if opts != nil {
		s.body = opts.Body
	}
	return json.RawMessage(`{"id":"task_123","status":"processing"}`), nil
}

func TestTextToImageCreateSendsCorrectRequest(t *testing.T) {
	stub := &stubHTTPClient{}
	client := NewClientWithHTTP(stub)
	_, err := client.TextToImage.Create(context.Background(), TextToImageParams{
		Model:         Model45TextToImage,
		Prompt:        "a cat",
		AspectRatio:   "16:9",
		OutputQuality: "basic",
	})
	if err != nil {
		t.Fatal(err)
	}
	if stub.method != "POST" || stub.path != "/api/v1/seedream/text_to_image" {
		t.Fatalf("unexpected request: %s %s", stub.method, stub.path)
	}
	body, ok := stub.body.(map[string]any)
	if !ok {
		t.Fatalf("expected flat body map, got %T", stub.body)
	}
	if body["model"] != string(Model45TextToImage) || body["output_quality"] != "basic" {
		t.Fatalf("unexpected body: %#v", body)
	}
	if _, ok := body["quality"]; ok {
		t.Fatal("expected request body to omit quality")
	}
}

func TestTextToImageGetSendsCorrectPath(t *testing.T) {
	stub := &stubHTTPClient{}
	client := NewClientWithHTTP(stub)
	_, err := client.TextToImage.Get(context.Background(), "task_abc")
	if err != nil {
		t.Fatal(err)
	}
	if stub.method != "GET" || stub.path != "/api/v1/seedream/text_to_image/task_abc" {
		t.Fatalf("unexpected request: %s %s", stub.method, stub.path)
	}
}

func TestEditImageCreateSendsCorrectPath(t *testing.T) {
	stub := &stubHTTPClient{}
	client := NewClientWithHTTP(stub)
	_, err := client.EditImage.Create(context.Background(), EditImageParams{
		Model:           Model5LiteEdit,
		Prompt:          "restyle",
		SourceImageURLs: []string{"https://cdn.runapi.ai/public/samples/input.png"},
		AspectRatio:     "1:1",
		OutputQuality:   "high",
		OutputFormat:    "jpeg",
	})
	if err != nil {
		t.Fatal(err)
	}
	if stub.method != "POST" || stub.path != "/api/v1/seedream/edit_image" {
		t.Fatalf("unexpected request: %s %s", stub.method, stub.path)
	}
	body := stub.body.(map[string]any)
	if body["model"] != string(Model5LiteEdit) || body["source_image_urls"].([]any)[0] != "https://cdn.runapi.ai/public/samples/input.png" {
		t.Fatalf("unexpected edit body: %#v", body)
	}
	if body["output_format"] != "jpeg" {
		t.Fatalf("unexpected output_format: %#v", body)
	}
}

func TestSeedream5ProRequestsUsePublicModelIDs(t *testing.T) {
	stub := &stubHTTPClient{}
	client := NewClientWithHTTP(stub)
	_, err := client.TextToImage.Create(context.Background(), TextToImageParams{
		Model:         Model5ProT2I,
		Prompt:        "a photorealistic rooftop cafe at sunrise",
		AspectRatio:   "21:9",
		OutputQuality: "high",
		OutputFormat:  "jpeg",
	})
	if err != nil {
		t.Fatal(err)
	}
	body := stub.body.(map[string]any)
	if body["model"] != string(Model5ProT2I) || body["output_format"] != "jpeg" {
		t.Fatalf("unexpected 5 Pro text body: %#v", body)
	}

	_, err = client.EditImage.Create(context.Background(), EditImageParams{
		Model:           Model5ProEdit,
		Prompt:          "turn the material into transparent glass",
		SourceImageURLs: []string{"https://cdn.runapi.ai/public/samples/image.jpg"},
		AspectRatio:     "3:2",
		OutputQuality:   "basic",
		OutputFormat:    "png",
	})
	if err != nil {
		t.Fatal(err)
	}
	body = stub.body.(map[string]any)
	if body["model"] != string(Model5ProEdit) || body["source_image_urls"] == nil {
		t.Fatalf("unexpected 5 Pro edit body: %#v", body)
	}
}

func TestTextToImageCreateSendsV4Fields(t *testing.T) {
	stub := &stubHTTPClient{}
	client := NewClientWithHTTP(stub)
	outputCount := 3
	seed := 12345
	enableSafetyChecker := true
	_, err := client.TextToImage.Create(context.Background(), TextToImageParams{
		Model:               ModelV4TextToImage,
		Prompt:              "a glass teapot product render",
		AspectRatio:         "16:9",
		OutputResolution:    "2k",
		OutputCount:         &outputCount,
		Seed:                &seed,
		EnableSafetyChecker: &enableSafetyChecker,
	})
	if err != nil {
		t.Fatal(err)
	}
	body := stub.body.(map[string]any)
	if body["model"] != string(ModelV4TextToImage) || body["aspect_ratio"] != "16:9" || body["output_resolution"] != "2k" {
		t.Fatalf("unexpected v4 body: %#v", body)
	}
	if body["output_count"] != float64(3) || body["seed"] != float64(12345) || body["enable_safety_checker"] != true {
		t.Fatalf("unexpected v4 numeric/body fields: %#v", body)
	}
	if _, ok := body["image_size"]; ok {
		t.Fatal("expected request body to omit image_size")
	}
	if _, ok := body["image_resolution"]; ok {
		t.Fatal("expected request body to omit image_resolution")
	}
}

func TestTextToImageCreateCompactsEmptyCallback(t *testing.T) {
	stub := &stubHTTPClient{}
	client := NewClientWithHTTP(stub)
	_, err := client.TextToImage.Create(context.Background(), TextToImageParams{
		Model:         Model5LiteT2I,
		Prompt:        "a cat",
		AspectRatio:   "1:1",
		OutputQuality: "high",
	})
	if err != nil {
		t.Fatal(err)
	}
	body := stub.body.(map[string]any)
	if _, ok := body["callback_url"]; ok {
		t.Fatal("expected empty callback_url to be compacted away")
	}
}

func TestDecomposeLayersCreateAndGet(t *testing.T) {
	stub := &stubHTTPClient{}
	client := NewClientWithHTTP(stub)
	_, err := client.DecomposeLayers.Create(context.Background(), DecomposeLayersParams{
		Model:        Model5ProLayerDecomposition,
		ImageURL:     "https://cdn.runapi.ai/public/samples/image.jpg",
		Size:         "1K",
		OutputFormat: "png",
	})
	if err != nil {
		t.Fatal(err)
	}
	if stub.method != "POST" || stub.path != "/api/v1/seedream/decompose_layers" {
		t.Fatalf("unexpected request: %s %s", stub.method, stub.path)
	}
	body := stub.body.(map[string]any)
	if body["model"] != string(Model5ProLayerDecomposition) || body["image_url"] != "https://cdn.runapi.ai/public/samples/image.jpg" {
		t.Fatalf("unexpected decomposition body: %#v", body)
	}

	_, err = client.DecomposeLayers.Get(context.Background(), "task_layers")
	if err != nil {
		t.Fatal(err)
	}
	if stub.method != "GET" || stub.path != "/api/v1/seedream/decompose_layers/task_layers" {
		t.Fatalf("unexpected request: %s %s", stub.method, stub.path)
	}
}
