# frozen_string_literal: true

# This file contains configuration for rack_test gem.

require 'rack/test'

RSpec.configure do |config|
  config.include Rack::Test::Methods, type: :request

  def app
    App.freeze.app
  end
end
