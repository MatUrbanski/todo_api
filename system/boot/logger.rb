# frozen_string_literal: true

# This file contains logger configuration.

Application.boot(:logger) do
  init do
    require 'logger'
  end

  start do
    # Define Logger instance.
    logger = Logger.new($stdout)

    # Because the Logger's level is set to WARN , only the warning, error, and fatal messages are recorded.
    logger.level = Logger::WARN if Application.env == 'test'

    # Register logger component.
    register(:logger, logger)
  end
end
