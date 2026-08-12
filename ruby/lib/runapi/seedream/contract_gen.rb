# frozen_string_literal: true

module RunApi
  module Seedream
    CONTRACT = {
      "decompose-layers" => {
        "models" => ["seedream-5-pro-layer-decomposition"],
        "fields_by_model" => {
          "seedream-5-pro-layer-decomposition" => {
            "image_url" => {
              "required" => true
            },
            "output_format" => {
              "enum" => ["png", "jpeg"]
            },
            "prompt" => {
              "max" => 5000,
              "length" => true
            },
            "size" => {
              "enum" => ["auto", "1K", "1.5K", "2K"]
            }
          }
        }
      },
      "edit-image" => {
        "models" => ["seedream-4.5-edit", "seedream-5-lite-edit", "seedream-5-pro-edit", "seedream-v4-edit"],
        "fields_by_model" => {
          "seedream-4.5-edit" => {
            "aspect_ratio" => {
              "enum" => ["1:1", "4:3", "3:4", "16:9", "9:16", "2:3", "3:2", "21:9"],
              "required" => true
            },
            "output_count" => {
              "type" => "integer"
            },
            "output_quality" => {
              "enum" => ["basic", "high"],
              "required" => true
            },
            "seed" => {
              "type" => "integer"
            },
            "source_image_urls" => {
              "required" => true,
              "min_items" => 1,
              "max_items" => 14
            }
          },
          "seedream-5-lite-edit" => {
            "aspect_ratio" => {
              "enum" => ["1:1", "4:3", "3:4", "16:9", "9:16", "2:3", "3:2", "21:9"],
              "required" => true
            },
            "output_count" => {
              "type" => "integer"
            },
            "output_format" => {
              "enum" => ["png", "jpeg"]
            },
            "output_quality" => {
              "enum" => ["basic", "high", "ultra"],
              "required" => true
            },
            "seed" => {
              "type" => "integer"
            },
            "source_image_urls" => {
              "required" => true,
              "min_items" => 1,
              "max_items" => 14
            }
          },
          "seedream-5-pro-edit" => {
            "aspect_ratio" => {
              "enum" => ["1:1", "4:3", "3:4", "16:9", "9:16", "2:3", "3:2", "21:9"],
              "required" => true
            },
            "output_format" => {
              "enum" => ["png", "jpeg"]
            },
            "output_quality" => {
              "enum" => ["basic", "high"],
              "required" => true
            },
            "prompt" => {
              "required" => true,
              "min" => 3,
              "max" => 5000,
              "length" => true
            },
            "source_image_urls" => {
              "required" => true,
              "min_items" => 1,
              "max_items" => 10
            }
          },
          "seedream-v4-edit" => {
            "aspect_ratio" => {
              "enum" => ["1:1", "4:3", "3:4", "3:2", "2:3", "16:9", "9:16", "21:9"]
            },
            "output_count" => {
              "enum" => [1, 2, 3, 4, 5, 6],
              "type" => "integer"
            },
            "output_resolution" => {
              "enum" => ["1k", "2k", "4k"]
            },
            "seed" => {
              "type" => "integer"
            },
            "source_image_urls" => {
              "required" => true,
              "min_items" => 1,
              "max_items" => 10
            }
          }
        },
        "rules" => [{
          "when" => {
            "model" => "seedream-4.5-edit"
          },
          "forbidden" => ["output_format"]
        }, {
          "when" => {
            "model" => "seedream-5-pro-edit"
          },
          "forbidden" => ["output_resolution", "output_count", "seed"]
        }, {
          "when" => {
            "model" => "seedream-v4-edit"
          },
          "forbidden" => ["output_format"]
        }]
      },
      "text-to-image" => {
        "models" => ["seedream-4.5-text-to-image", "seedream-5-lite-text-to-image", "seedream-5-pro-text-to-image", "seedream-v4-text-to-image"],
        "fields_by_model" => {
          "seedream-4.5-text-to-image" => {
            "aspect_ratio" => {
              "enum" => ["1:1", "4:3", "3:4", "16:9", "9:16", "2:3", "3:2", "21:9"],
              "required" => true
            },
            "output_count" => {
              "type" => "integer"
            },
            "output_quality" => {
              "enum" => ["basic", "high"],
              "required" => true
            },
            "seed" => {
              "type" => "integer"
            }
          },
          "seedream-5-lite-text-to-image" => {
            "aspect_ratio" => {
              "enum" => ["1:1", "4:3", "3:4", "16:9", "9:16", "2:3", "3:2", "21:9"],
              "required" => true
            },
            "output_count" => {
              "type" => "integer"
            },
            "output_format" => {
              "enum" => ["png", "jpeg"]
            },
            "output_quality" => {
              "enum" => ["basic", "high", "ultra"],
              "required" => true
            },
            "seed" => {
              "type" => "integer"
            }
          },
          "seedream-5-pro-text-to-image" => {
            "aspect_ratio" => {
              "enum" => ["1:1", "4:3", "3:4", "16:9", "9:16", "2:3", "3:2", "21:9"],
              "required" => true
            },
            "output_format" => {
              "enum" => ["png", "jpeg"]
            },
            "output_quality" => {
              "enum" => ["basic", "high"],
              "required" => true
            },
            "prompt" => {
              "required" => true,
              "min" => 3,
              "max" => 5000,
              "length" => true
            }
          },
          "seedream-v4-text-to-image" => {
            "aspect_ratio" => {
              "enum" => ["1:1", "4:3", "3:4", "3:2", "2:3", "16:9", "9:16", "21:9"]
            },
            "output_count" => {
              "enum" => [1, 2, 3, 4, 5, 6],
              "type" => "integer"
            },
            "output_resolution" => {
              "enum" => ["1k", "2k", "4k"]
            },
            "seed" => {
              "type" => "integer"
            }
          }
        },
        "rules" => [{
          "when" => {
            "model" => "seedream-4.5-text-to-image"
          },
          "forbidden" => ["output_format"]
        }, {
          "when" => {
            "model" => "seedream-5-pro-text-to-image"
          },
          "forbidden" => ["output_resolution", "output_count", "seed"]
        }, {
          "when" => {
            "model" => "seedream-v4-text-to-image"
          },
          "forbidden" => ["output_format"]
        }]
      }
    }.freeze
  end
end
