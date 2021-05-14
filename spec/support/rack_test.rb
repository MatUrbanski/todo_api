# frozen_string_literal: true

# This file contains configuration for rack_test gem.

require 'rack/test'

RSpec.configure do |config|
  config.include Rack::Test::Methods, type: :request
  config.include Rack::Test::Methods, type: :throttling

  def app
    Rack::Builder.parse_file('config.ru').first
  end
end
