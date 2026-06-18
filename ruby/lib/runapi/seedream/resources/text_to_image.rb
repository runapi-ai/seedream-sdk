# frozen_string_literal: true

module RunApi
  module Seedream
    module Resources
      # Seedream text-to-image generation resource.
      # Field requirements vary by model: 4.5/5-lite require aspect_ratio and
      # output_quality; V4 uses output_resolution and supports seed/output_count.
      class TextToImage
        include RunApi::Core::ResourceHelpers

        ENDPOINT = "/api/v1/seedream/text_to_image"
        RESPONSE_CLASS = Types::TextToImageResponse
        COMPLETED_RESPONSE_CLASS = Types::CompletedTextToImageResponse
        PROMPT_MAX_LENGTH = 3000
        V4_PROMPT_MAX_LENGTH = 5000
        PROMPT_MIN_LENGTH_LITE = 3
        V4_OUTPUT_COUNT_RANGE = (1..6)

        def initialize(http)
          @http = http
        end

        def run(**params)
          task = create(**params)
          poll_until_complete { get(task.id) }
        end

        def create(**params)
          params = compact_params(params)
          validate_params!(params)
          request(:post, ENDPOINT, body: params)
        end

        def get(id)
          request(:get, "#{ENDPOINT}/#{id}")
        end

        private

        def validate_params!(params)
          model = param(params, :model)
          raise Core::ValidationError, "model is required" unless model
          unless Types::TEXT_TO_IMAGE_MODELS.include?(model)
            raise Core::ValidationError, "Invalid model: #{model}. Must be one of: #{Types::TEXT_TO_IMAGE_MODELS.join(", ")}"
          end

          prompt = param(params, :prompt)
          raise Core::ValidationError, "prompt is required" unless prompt.is_a?(String) && !prompt.empty?
          max_length = Types::V4_MODELS.include?(model) ? V4_PROMPT_MAX_LENGTH : PROMPT_MAX_LENGTH
          raise Core::ValidationError, "prompt must be at most #{max_length} characters" if prompt.length > max_length
          if Types::LITE_MODELS.include?(model) && prompt.length < PROMPT_MIN_LENGTH_LITE
            raise Core::ValidationError, "prompt must be between #{PROMPT_MIN_LENGTH_LITE} and #{PROMPT_MAX_LENGTH} characters"
          end

          if Types::V4_MODELS.include?(model)
            validate_optional!(params, :aspect_ratio, Types::ASPECT_RATIOS)
            validate_optional!(params, :output_resolution, Types::V4_OUTPUT_RESOLUTIONS)
            validate_integer_range!(params, :output_count, V4_OUTPUT_COUNT_RANGE)
            validate_integer!(params, :seed)
          else
            validate_required!(params, :aspect_ratio)
            validate_required!(params, :output_quality)
            validate_optional!(params, :aspect_ratio, Types::ASPECT_RATIOS)
            validate_optional!(params, :output_quality, Types::OUTPUT_QUALITIES)
          end

          if field_present?(params, :source_image_urls)
            raise Core::ValidationError, "source_image_urls is not supported for #{model}"
          end
        end

        def validate_required!(params, key)
          raise Core::ValidationError, "#{key} is required" unless field_present?(params, key)
        end

        def field_present?(params, key)
          value = param(params, key)
          return false if value.nil?
          return value.any? if value.is_a?(Array)
          return !value.empty? if value.respond_to?(:empty?)

          true
        end

        def validate_integer!(params, key)
          value = param(params, key)
          return if value.nil?
          return if value.is_a?(Integer)

          raise Core::ValidationError, "#{key} must be an integer"
        end

        def validate_integer_range!(params, key, range)
          value = param(params, key)
          return if value.nil?

          return if value.is_a?(Integer) && range.cover?(value)

          raise Core::ValidationError, "#{key} must be between #{range.first} and #{range.last}"
        end
      end
    end
  end
end
