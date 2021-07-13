# frozen_string_literal: true

# This file contains configuration to let the webserver which application to run.

require_relative 'app'

# Enable Rack::Attack
use Rack::Attack

# Rack::Session::Cookie provides simple cookie based session management.
# By default, the session is a Ruby Hash stored as base64 encoded marshalled data set to :key (default: rack.session).
Sidekiq::Web.use(Rack::Session::Cookie, secret: ENV['SECRET_KEY_BASE'])

# Secure Sidekiq::Web dashboard with HTTP Basic Authentication using Rack::Auth::Basic.
Sidekiq::Web.use(Rack::Auth::Basic) do |username, password|
  [username, password] == [ENV['SIDEKIQ_USER'], ENV['SIDEKIQ_PASSWORD']]
end

# Rack::URLMap takes a hash mapping urls or paths to apps, and dispatches accordingly.
run Rack::URLMap.new('/' => App.freeze.app, '/sidekiq' => Sidekiq::Web)
