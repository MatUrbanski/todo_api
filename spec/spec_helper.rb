# frozen_string_literal: true

# Set RACK_ENV to test.
ENV['RACK_ENV'] = 'test'

require_relative '../app'

# Require all files in spec/support folder.
root_path = Pathname.new(File.expand_path('..', __dir__))
Dir[root_path.join('spec/support/**/*.rb')].each { |f| require f }
