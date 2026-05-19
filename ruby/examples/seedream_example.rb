# frozen_string_literal: true

require "runapi/seedream"

client = RunApi::Seedream::Client.new(api_key: ENV.fetch("RUNAPI_API_KEY"))

task = client.text_to_image.create(
  model: "seedream-4.5-text-to-image",
  prompt: "A cinematic portrait of a traveler in the rain",
  aspect_ratio: "16:9",
  quality: "basic"
)

puts "Task ID: #{task.id}"
