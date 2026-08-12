# frozen_string_literal: true

require "spec_helper"

RSpec.describe RunApi::Seedream::Client do
  before do
    allow(ConnectionPool).to receive(:new).and_return(instance_double(ConnectionPool))
  end

  after { RunApi.api_key = nil }

  it "accepts api_key as parameter" do
    client = described_class.new(api_key: "param-key")
    expect(client).to be_a(described_class)
  end

  it "falls back to global RunApi.api_key" do
    RunApi.api_key = "global-key"
    client = described_class.new
    expect(client).to be_a(described_class)
  end

  it "exposes text_to_image accessor" do
    client = described_class.new(api_key: "test-key")
    expect(client.text_to_image).to be_a(RunApi::Seedream::Resources::TextToImage)
  end

  it "exposes edit_image accessor" do
    client = described_class.new(api_key: "test-key")
    expect(client.edit_image).to be_a(RunApi::Seedream::Resources::EditImage)
  end

  it "exposes decompose_layers accessor" do
    client = described_class.new(api_key: "test-key")
    expect(client.decompose_layers).to be_a(RunApi::Seedream::Resources::DecomposeLayers)
  end
end
