# frozen_string_literal: true

module RunApi
  module Seedream
    # Seedream type constants and response models.
    # Model families differ in supported params: 4.5/5-lite require aspect_ratio
    # and output_quality; V4 uses output_resolution and supports seed/output_count.
    module Types
      # Model groupings used by bespoke prompt-length selection (a per-model rule
      # the contract cannot express). Model membership and field enums are
      # validated by the generated CONTRACT.
      LITE_MODELS = %w[seedream-5-lite-text-to-image seedream-5-lite-edit].freeze
      V4_MODELS = %w[seedream-v4-text-to-image seedream-v4-edit].freeze

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
