# frozen_string_literal: true

module RunApi
  module Seedream
    # Seedream type constants and response models.
    # Model families differ in supported params: 4.5/5-lite require aspect_ratio
    # and output_quality; V4 uses output_resolution and supports seed/output_count.
    module Types
      MODELS = %w[
        seedream-4.5-text-to-image
        seedream-4.5-edit
        seedream-5-lite-text-to-image
        seedream-5-lite-edit
        seedream-v4-text-to-image
        seedream-v4-edit
      ].freeze
      TEXT_TO_IMAGE_MODELS = %w[seedream-4.5-text-to-image seedream-5-lite-text-to-image seedream-v4-text-to-image].freeze
      EDIT_MODELS = %w[seedream-4.5-edit seedream-5-lite-edit seedream-v4-edit].freeze
      LITE_MODELS = %w[seedream-5-lite-text-to-image seedream-5-lite-edit].freeze
      V4_MODELS = %w[seedream-v4-text-to-image seedream-v4-edit].freeze
      ASPECT_RATIOS = %w[1:1 4:3 3:4 16:9 9:16 2:3 3:2 21:9].freeze
      OUTPUT_QUALITIES = %w[basic high].freeze
      V4_OUTPUT_RESOLUTIONS = %w[1k 2k 4k].freeze

      class Image < RunApi::Core::BaseModel
        optional :url, String
      end

      class TextToImageResponse < RunApi::Core::TaskResponse
        required :id, String
        optional :status, String, enum: -> { RunApi::Core::TaskResponse::Status::ALL }
        optional :images, [-> { Image }]
        optional :error, String
      end

      EditImageResponse = TextToImageResponse

      # Narrowed response returned by `text_to_image.run()` once polling observes
      # `status: "completed"`. `images` is required so consumers never have to
      # null-check it on a successful task.
      class CompletedTextToImageResponse < TextToImageResponse
        required :images, [-> { Image }]
      end

      CompletedEditImageResponse = CompletedTextToImageResponse
    end
  end
end
