# frozen_string_literal: true

# This file contain configuration for Sidekiq.

Application.boot(:sidekiq) do
  # Load environment variables before setting up redis connection.
  use :environment_variables

  init do
    require 'sidekiq'
    require 'sidekiq/web'
  end

  start do
    # Configuration for Sidekiq server.
    Sidekiq.configure_server do |config|
      config.redis = { url: ENV['REDIS_URL'] }
    end

    # Configuration for Sidekiq client.
    Sidekiq.configure_client do |config|
      config.redis = { url: ENV['REDIS_URL'] }
    end
  end
end
