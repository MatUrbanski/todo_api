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
end

RSpec.configure do |config|
  config.include ApiHelpers
end
