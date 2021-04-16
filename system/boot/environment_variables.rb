# frozen_string_literal: true

# This file contains setup for environment variables using Dotenv.

Application.boot(:environment_variables) do
  start do
    # Get Application current environment.
    env = Application.env

    # Load environment variables if current environment is development or test.
    if %w[development test].include?(env)
      require 'dotenv'

      Dotenv.load('.env', ".env.#{env}")
    end
  end
end
