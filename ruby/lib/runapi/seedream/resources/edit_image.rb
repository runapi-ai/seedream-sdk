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

        def initialize(http)
          @http = http
        end

        def run(options: nil, **params)
          task = create(options: options, **params)
          poll_until_complete { get(task.id, options: options) }
        end

        def create(options: nil, **params)
          params = compact_params(params)
          request(:post, ENDPOINT, body: params, options: options)
        end

        def get(id, options: nil)
          request(:get, "#{ENDPOINT}/#{id}", options: options)
        end
      end
    end
  end
end
