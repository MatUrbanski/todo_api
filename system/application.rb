# frozen_string_literal: true

require 'bundler/setup'
require 'dry/system/container'
require 'zeitwerk'

# {Application} is a container that we use it to register dependencies we need to call.
class Application < Dry::System::Container
  # Provide environment inferrerr.
  use :env, inferrer: -> { ENV.fetch('RACK_ENV', 'development') }

  configure do |_config|
    loader  = Zeitwerk::Loader.new
    folders = Dir.glob('./app/*') + ['./lib']

    folders.each do |folder|
      loader.push_dir(Application.config.root.join(folder).realpath)
    end

    loader.setup
  end
end
