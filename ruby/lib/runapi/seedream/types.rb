# frozen_string_literal: true

module RunApi
  module Seedream
    # Seedream type constants and response models.
    # Model families differ in supported params: 4.5/5-Lite/5 Pro require
    # aspect_ratio and output_quality; 5-Lite/5 Pro also support output_format; V4 uses
    # output_resolution and supports seed/output_count.
    module Types
      class Image < RunApi::Core::BaseModel
        optional :url, String
      end

      class BoundingBox < RunApi::Core::BaseModel
        optional :absolute, [Integer]
        optional :normalized, [Integer]
      end

      class Layer < RunApi::Core::BaseModel
        required :url, String
        required :z_index, Integer
        optional :bounding_box, -> { BoundingBox }
        optional :name, String
        optional :description, String
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

      class DecomposeLayersResponse < RunApi::Core::TaskResponse
        required :id, String
        optional :status, String, enum: -> { RunApi::Core::TaskResponse::Status::ALL }
        optional :base_image, -> { Image }
        optional :layers, [-> { Layer }]
        optional :error, String
      end

      class CompletedDecomposeLayersResponse < DecomposeLayersResponse
        required :base_image, -> { Image }
        required :layers, [-> { Layer }]
      end
    end
  end
end
