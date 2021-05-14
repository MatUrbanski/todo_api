# frozen_string_literal: true

# This file contain code to setup the redis connection.

Application.boot(:redis) do |container|
  # Load environment variables before setting up redis connection.
  use :environment_variables

  init do
    require 'redis'
  end

  start do
    # Define Redis instance.
    redis = Redis.new(url: ENV['REDIS_URL'])

    # Register redis component.
    container.register(:redis, redis)
  end
end
