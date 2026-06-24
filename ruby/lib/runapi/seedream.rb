# frozen_string_literal: true

require "runapi/core"
require_relative "seedream/types"
require_relative "seedream/contract_gen"
require_relative "seedream/resources/text_to_image"
require_relative "seedream/resources/edit_image"
require_relative "seedream/client"

module RunApi
  module Seedream
    AuthenticationError = RunApi::Core::AuthenticationError
    RateLimitError = RunApi::Core::RateLimitError
    InsufficientCreditsError = RunApi::Core::InsufficientCreditsError
    NotFoundError = RunApi::Core::NotFoundError
    ValidationError = RunApi::Core::ValidationError
    TaskFailedError = RunApi::Core::TaskFailedError
    TaskTimeoutError = RunApi::Core::TaskTimeoutError
  end
end
