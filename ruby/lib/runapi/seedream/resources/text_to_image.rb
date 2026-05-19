# frozen_string_literal: true

module RunApi
  module Seedream
    module Resources
      class TextToImage
        include RunApi::Core::ResourceHelpers

        ENDPOINT = "/api/v1/seedream/text_to_image"
        RESPONSE_CLASS = Types::TextToImageResponse
        COMPLETED_RESPONSE_CLASS = Types::CompletedTextToImageResponse
        PROMPT_MAX_LENGTH = 3000
        PROMPT_MIN_LENGTH_LITE = 3

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
          raise Core::ValidationError, "Invalid model: #{model}. Must be one of: #{Types::MODELS.join(", ")}" unless Types::MODELS.include?(model)

          prompt = param(params, :prompt)
          raise Core::ValidationError, "prompt is required" unless prompt.is_a?(String) && !prompt.empty?
          raise Core::ValidationError, "prompt must be at most #{PROMPT_MAX_LENGTH} characters" if prompt.length > PROMPT_MAX_LENGTH
          if Types::LITE_MODELS.include?(model) && prompt.length < PROMPT_MIN_LENGTH_LITE
            raise Core::ValidationError, "prompt must be between #{PROMPT_MIN_LENGTH_LITE} and #{PROMPT_MAX_LENGTH} characters"
          end

          validate_required!(params, :aspect_ratio)
          validate_required!(params, :quality)
          validate_optional!(params, :aspect_ratio, Types::ASPECT_RATIOS)
          validate_optional!(params, :quality, Types::QUALITIES)

          if Types::IMAGE_MODELS.include?(model)
            raise Core::ValidationError, "image_urls is required" unless field_present?(params, :image_urls)
          elsif field_present?(params, :image_urls)
            raise Core::ValidationError, "image_urls is not supported for #{model}"
          end

          if field_present?(params, :nsfw_checker) && !Types::LITE_MODELS.include?(model)
            raise Core::ValidationError, "nsfw_checker is not supported for #{model}"
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
      end
    end
  end
end
