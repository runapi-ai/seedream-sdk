CONTRACT = {
    "edit-image": {
        "models": ["seedream-4.5-edit", "seedream-5-lite-edit", "seedream-v4-edit"],
        "fields_by_model": {
            "seedream-4.5-edit": {
                "aspect_ratio": {
                    "enum": ["1:1", "4:3", "3:4", "16:9", "9:16", "2:3", "3:2", "21:9"],
                    "required": True
                },
                "output_count": {
                    "type": "integer"
                },
                "output_quality": {
                    "enum": ["basic", "high"],
                    "required": True
                },
                "seed": {
                    "type": "integer"
                },
                "source_image_urls": {
                    "required": True
                }
            },
            "seedream-5-lite-edit": {
                "aspect_ratio": {
                    "enum": ["1:1", "4:3", "3:4", "16:9", "9:16", "2:3", "3:2", "21:9"],
                    "required": True
                },
                "output_count": {
                    "type": "integer"
                },
                "output_quality": {
                    "enum": ["basic", "high"],
                    "required": True
                },
                "seed": {
                    "type": "integer"
                },
                "source_image_urls": {
                    "required": True
                }
            },
            "seedream-v4-edit": {
                "aspect_ratio": {
                    "enum": ["1:1", "4:3", "3:4", "3:2", "2:3", "16:9", "9:16", "21:9"]
                },
                "output_count": {
                    "enum": [1, 2, 3, 4, 5, 6],
                    "type": "integer"
                },
                "output_resolution": {
                    "enum": ["1k", "2k", "4k"]
                },
                "seed": {
                    "type": "integer"
                },
                "source_image_urls": {
                    "required": True
                }
            }
        }
    },
    "text-to-image": {
        "models": ["seedream-4.5-text-to-image", "seedream-5-lite-text-to-image", "seedream-v4-text-to-image"],
        "fields_by_model": {
            "seedream-4.5-text-to-image": {
                "aspect_ratio": {
                    "enum": ["1:1", "4:3", "3:4", "16:9", "9:16", "2:3", "3:2", "21:9"],
                    "required": True
                },
                "output_count": {
                    "type": "integer"
                },
                "output_quality": {
                    "enum": ["basic", "high"],
                    "required": True
                },
                "seed": {
                    "type": "integer"
                }
            },
            "seedream-5-lite-text-to-image": {
                "aspect_ratio": {
                    "enum": ["1:1", "4:3", "3:4", "16:9", "9:16", "2:3", "3:2", "21:9"],
                    "required": True
                },
                "output_count": {
                    "type": "integer"
                },
                "output_quality": {
                    "enum": ["basic", "high"],
                    "required": True
                },
                "seed": {
                    "type": "integer"
                }
            },
            "seedream-v4-text-to-image": {
                "aspect_ratio": {
                    "enum": ["1:1", "4:3", "3:4", "3:2", "2:3", "16:9", "9:16", "21:9"]
                },
                "output_count": {
                    "enum": [1, 2, 3, 4, 5, 6],
                    "type": "integer"
                },
                "output_resolution": {
                    "enum": ["1k", "2k", "4k"]
                },
                "seed": {
                    "type": "integer"
                }
            }
        }
    }
}
