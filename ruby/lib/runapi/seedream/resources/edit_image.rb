# frozen_string_literal: true

module RunApi
  module Seedream
    module Resources
      # Seedream image editing resource.
      # Modifies source images according to a text prompt.
      # 5 Pro and V4 accept up to 10 source images; 4.5 and 5-Lite accept up to 14.
      class EditImage
        include RunApi::Core::ResourceHelpers

        ENDPOINT = "/api/v1/seedream/edit_image"
        RESPONSE_CLASS = Types::EditImageResponse
        COMPLETED_RESPONSE_CLASS = Types::CompletedEditImageResponse
        PROMPT_MAX_LENGTH = 3000
        V4_PROMPT_MAX_LENGTH = 5000
        PROMPT_MIN_LENGTH_LITE = 3

        def initialize(http)
          @http = http
        end

        def run(options: nil, **params)
          task = create(options: options, **params)
          poll_until_complete { get(task.id, options: options) }
        end

        def create(options: nil, **params)
          params = compact_params(params)
          validate_params!(params)
          request(:post, ENDPOINT, body: params, options: options)
        end

        def get(id, options: nil)
          request(:get, "#{ENDPOINT}/#{id}", options: options)
        end

        private

        def validate_params!(params)
          validate_contract!(CONTRACT["edit-image"], params)

          model = param(params, :model)

          prompt = param(params, :prompt)
          raise Core::ValidationError, "prompt is required" unless prompt.is_a?(String) && !prompt.empty?
          max_length = Types::LONG_PROMPT_MODELS.include?(model) ? V4_PROMPT_MAX_LENGTH : PROMPT_MAX_LENGTH
          raise Core::ValidationError, "prompt must be at most #{max_length} characters" if prompt.length > max_length
          if Types::MINIMUM_THREE_PROMPT_MODELS.include?(model) && prompt.length < PROMPT_MIN_LENGTH_LITE
            raise Core::ValidationError, "prompt must be between #{PROMPT_MIN_LENGTH_LITE} and #{max_length} characters"
          end

          validate_integer!(params, :seed) if Types::V4_MODELS.include?(model)
        end

        def validate_integer!(params, key)
          value = param(params, key)
          return if value.nil?
          return if value.is_a?(Integer)

          raise Core::ValidationError, "#{key} must be an integer"
        end
      end
    end
  end
end
