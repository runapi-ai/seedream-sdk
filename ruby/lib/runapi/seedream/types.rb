# frozen_string_literal: true

module RunApi
  module Seedream
    module Types
      MODELS = %w[
        seedream-4.5-text-to-image
        seedream-4.5-edit
        seedream-5-lite-text-to-image
        seedream-5-lite-image-to-image
      ].freeze
      IMAGE_MODELS = %w[seedream-4.5-edit seedream-5-lite-image-to-image].freeze
      LITE_MODELS = %w[seedream-5-lite-text-to-image seedream-5-lite-image-to-image].freeze
      ASPECT_RATIOS = %w[1:1 4:3 3:4 16:9 9:16 2:3 3:2 21:9].freeze
      QUALITIES = %w[basic high].freeze

      class Image < RunApi::Core::BaseModel
        optional :url, String
      end

      class TextToImageResponse < RunApi::Core::TaskResponse
        required :id, String
        optional :status, String, enum: -> { RunApi::Core::TaskResponse::Status::ALL }
        optional :images, [ -> { Image } ]
        optional :error, String
      end

      # Narrowed response returned by `text_to_image.run()` once polling observes
      # `status: "completed"`. `images` is required so consumers never have to
      # null-check it on a successful task.
      class CompletedTextToImageResponse < TextToImageResponse
        required :images, [ -> { Image } ]
      end
    end
  end
end
