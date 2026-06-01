# frozen_string_literal: true

require "runapi/seedream"

client = RunApi::Seedream::Client.new(api_key: ENV.fetch("RUNAPI_API_KEY"))

task = client.text_to_image.create(
  model: "seedream-v4-text-to-image",
  prompt: "A precise product render of a glass teapot on white marble",
  aspect_ratio: "16:9",
  output_resolution: "2k",
  output_count: 3
)

puts "Task ID: #{task.id}"
