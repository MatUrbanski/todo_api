# frozen_string_literal: true

# {ApiHelpers} module contains helper methods that are used in the API request specs.
module ApiHelpers
  # It returns the response that our request has returned.
  def response
    last_response
  end

  # It parse the response JSON document into a Ruby data structure and return it.
  def json_response
    JSON.parse(response.body)
  end

  # It generates access token for {User}.
  #
  # @see AccessTokenGenerator
  def access_token(user)
    AccessTokenGenerator.new(user: user).call
  end

  # It generates refresh token for {User}.
  #
  # @see RefreshTokenGenerator
  def refresh_token(user)
    RefreshTokenGenerator.new(user: user).call
  end
end

RSpec.configure do |config|
  config.include ApiHelpers
end
