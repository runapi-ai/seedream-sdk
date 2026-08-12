# frozen_string_literal: true

module RunApi
  module Seedream
    module Resources
      # Separates one image into a base image and independent layers.
      class DecomposeLayers
        include RunApi::Core::ResourceHelpers

        ENDPOINT = "/api/v1/seedream/decompose_layers"
        RESPONSE_CLASS = Types::DecomposeLayersResponse
        COMPLETED_RESPONSE_CLASS = Types::CompletedDecomposeLayersResponse

        def initialize(http)
          @http = http
        end

        def run(options: nil, **params)
          task = create(options: options, **params)
          poll_until_complete { get(task.id, options: options) }
        end

        def create(options: nil, **params)
          params = compact_params(params)
          validate_contract!(CONTRACT["decompose-layers"], params)
          request(:post, ENDPOINT, body: params, options: options)
        end

        def get(id, options: nil)
          request(:get, "#{ENDPOINT}/#{id}", options: options)
        end
      end
    end
  end
end
