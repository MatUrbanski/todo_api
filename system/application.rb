# frozen_string_literal: true

require 'bundler/setup'
require 'dry/system/container'

# {Application} is a container that we use it to register dependencies we need to call.
class Application < Dry::System::Container
  # Provide environment inferrerr.
  use :env, inferrer: -> { ENV.fetch('RACK_ENV', 'development') }

  # we set 'lib' relative to `root` as a path which contains class definitions
  # that can be auto-registered
  config.auto_register = %w[lib app]

  # this alters $LOAD_PATH hence the `!`
  load_paths!('lib', 'app')
end
