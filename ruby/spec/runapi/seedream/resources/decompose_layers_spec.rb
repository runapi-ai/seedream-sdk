# frozen_string_literal: true

require "spec_helper"

RSpec.describe RunApi::Seedream::Resources::DecomposeLayers do
  let(:http) { instance_double(RunApi::Core::HttpClient) }
  let(:resource) { described_class.new(http) }

  it "creates and gets layer decomposition tasks" do
    allow(http).to receive(:request)
      .with(:post, "/api/v1/seedream/decompose_layers", hash_including(body: hash_including(model: "seedream-5-pro-layer-decomposition")))
      .and_return({"id" => "task-1", "status" => "processing"})
    allow(http).to receive(:request)
      .with(:get, "/api/v1/seedream/decompose_layers/task-1")
      .and_return({
        "id" => "task-1",
        "status" => "completed",
        "base_image" => {"url" => "https://file.runapi.ai/base.jpeg"},
        "layers" => [{"url" => "https://file.runapi.ai/layer.png"}]
      })

    created = resource.create(
      model: "seedream-5-pro-layer-decomposition",
      image_url: "https://cdn.runapi.ai/public/samples/image.jpg"
    )
    result = resource.get(created.id)

    expect(result).to be_a(RunApi::Seedream::Types::DecomposeLayersResponse)
    expect(result.base_image.url).to eq("https://file.runapi.ai/base.jpeg")
  end
end
