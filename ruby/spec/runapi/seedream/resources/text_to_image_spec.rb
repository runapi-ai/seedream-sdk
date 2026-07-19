# frozen_string_literal: true

require "spec_helper"

RSpec.describe RunApi::Seedream::Resources::TextToImage do
  let(:http) { instance_double(RunApi::Core::HttpClient) }
  let(:text_to_image) { described_class.new(http) }
  let(:edit_image) { RunApi::Seedream::Resources::EditImage.new(http) }
  let(:endpoint) { "/api/v1/seedream/text_to_image" }
  let(:edit_endpoint) { "/api/v1/seedream/edit_image" }

  describe "#create" do
    it "POSTs to the correct endpoint with text-to-image params" do
      params = {model: "seedream-4.5-text-to-image", prompt: "a futuristic cityscape", aspect_ratio: "16:9", output_quality: "basic"}
      expect(http).to receive(:request).with(:post, endpoint, body: params).and_return("id" => "task-1")

      result = text_to_image.create(**params)
      expect(result).to be_a(RunApi::Seedream::Types::TextToImageResponse)
      expect(result.id).to eq("task-1")
    end

    it "POSTs with source_image_urls for image models" do
      params = {model: "seedream-5-lite-edit", prompt: "restyle", source_image_urls: ["https://cdn.runapi.ai/public/samples/input.png"], aspect_ratio: "1:1", output_quality: "high", enable_safety_checker: false}
      expect(http).to receive(:request).with(:post, edit_endpoint, body: params).and_return("id" => "task-2")

      result = edit_image.create(**params)
      expect(result.id).to eq("task-2")
    end

    it "POSTs v4 text-to-image params" do
      params = {
        model: "seedream-v4-text-to-image",
        prompt: "a glass teapot product render",
        aspect_ratio: "16:9",
        output_resolution: "2k",
        output_count: 3,
        seed: 12345,
        enable_safety_checker: true
      }
      expect(http).to receive(:request).with(:post, endpoint, body: params).and_return("id" => "task-v4")

      result = text_to_image.create(**params)
      expect(result.id).to eq("task-v4")
    end

    it "POSTs v4 edit params with source_image_urls" do
      params = {
        model: "seedream-v4-edit",
        prompt: "place the logo on a blue outdoor cap",
        source_image_urls: ["https://cdn.runapi.ai/public/samples/image.jpg"],
        aspect_ratio: "1:1",
        output_resolution: "4k",
        output_count: 1,
        enable_safety_checker: false
      }
      expect(http).to receive(:request).with(:post, edit_endpoint, body: params).and_return("id" => "task-v4-edit")

      result = edit_image.create(**params)
      expect(result.id).to eq("task-v4-edit")
    end

    it "raises ValidationError when source_image_urls is missing for image models" do
      expect {
        edit_image.create(model: "seedream-v4-edit", prompt: "test", aspect_ratio: "1:1")
      }.to raise_error(RunApi::Core::ValidationError, /source_image_urls is required/)
    end

    it "raises ValidationError when source_image_urls is sent for text models" do
      expect {
        text_to_image.create(model: "seedream-4.5-text-to-image", prompt: "test", source_image_urls: ["x"], aspect_ratio: "1:1", output_quality: "basic")
      }.to raise_error(RunApi::Core::ValidationError, /source_image_urls is not supported/)
    end

    it "POSTs enable_safety_checker for 4.5 models" do
      params = {model: "seedream-4.5-text-to-image", prompt: "test", aspect_ratio: "1:1", output_quality: "basic", enable_safety_checker: true}
      expect(http).to receive(:request).with(:post, endpoint, body: params).and_return("id" => "task-45-nsfw")

      result = text_to_image.create(**params)
      expect(result.id).to eq("task-45-nsfw")
    end

    it "raises ValidationError for invalid v4 output_count" do
      expect {
        text_to_image.create(model: "seedream-v4-text-to-image", prompt: "test", output_count: 7)
      }.to raise_error(RunApi::Core::ValidationError, /output_count must be one of: 1, 2, 3, 4, 5, 6/)
    end

    it "raises ValidationError for string v4 output_count" do
      expect {
        text_to_image.create(model: "seedream-v4-text-to-image", prompt: "test", output_count: "3")
      }.to raise_error(RunApi::Core::ValidationError, /output_count must be one of: 1, 2, 3, 4, 5, 6/)
    end

    it "raises ValidationError for string v4 seed" do
      expect {
        text_to_image.create(model: "seedream-v4-text-to-image", prompt: "test", seed: "12345")
      }.to raise_error(RunApi::Core::ValidationError, /seed must be an integer/)
    end

    it "raises ValidationError for invalid aspect_ratio" do
      expect {
        text_to_image.create(model: "seedream-4.5-text-to-image", prompt: "test", aspect_ratio: "auto", output_quality: "basic")
      }.to raise_error(RunApi::Core::ValidationError, /aspect_ratio must be one of:/)
    end

    it "raises ValidationError for short 5-lite prompt" do
      expect {
        text_to_image.create(model: "seedream-5-lite-text-to-image", prompt: "hi", aspect_ratio: "1:1", output_quality: "basic")
      }.to raise_error(RunApi::Core::ValidationError, /prompt must be between 3 and 3000 characters/)
    end
  end

  describe "#get" do
    it "GETs the correct endpoint" do
      expect(http).to receive(:request).with(:get, "#{endpoint}/task-1")
        .and_return("id" => "task-1", "status" => "completed")

      result = text_to_image.get("task-1")
      expect(result.status).to eq("completed")
    end
  end

  describe "#get on edit_image" do
    it "GETs the correct endpoint" do
      expect(http).to receive(:request).with(:get, "#{edit_endpoint}/task-2")
        .and_return("id" => "task-2", "status" => "completed")

      result = edit_image.get("task-2")
      expect(result.status).to eq("completed")
    end
  end
end
