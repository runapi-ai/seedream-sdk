# frozen_string_literal: true

module RunApi
  module Seedream
    # Seedream image generation and editing API client.
    #
    # Three model families with different field requirements:
    # - 4.5: requires aspect_ratio and output_quality
    # - 5-lite: same required fields as 4.5, faster generation
    # - V4: uses output_resolution instead; supports seed and batch output_count
    #
    # @example
    #   client = RunApi::Seedream::Client.new(api_key: "your-api-key")
    #
    #   # Seedream 4.5
    #   result = client.text_to_image.run(
    #     model: "seedream-4.5-text-to-image",
    #     prompt: "A beautiful product render",
    #     aspect_ratio: "16:9", output_quality: "high"
    #   )
    #
    #   # Seedream V4 with batch output
    #   batch = client.text_to_image.run(
    #     model: "seedream-v4-text-to-image",
    #     prompt: "Minimalist logo design", output_count: 4
    #   )
    class Client < RunApi::Core::Client
      # @return [Resources::TextToImage] Text-to-image generation across model versions.
      attr_reader :text_to_image
      # @return [Resources::EditImage] Edit source images with a text prompt.
      attr_reader :edit_image
      # @return [Resources::DecomposeLayers] Separate an image into editable layers.
      attr_reader :decompose_layers

      def initialize(api_key: nil, **options)
        super
        @text_to_image = Resources::TextToImage.new(http)
        @edit_image = Resources::EditImage.new(http)
        @decompose_layers = Resources::DecomposeLayers.new(http)
      end
    end
  end
end
