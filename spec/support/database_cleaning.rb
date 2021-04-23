# frozen_string_literal: true

# This file contains configuration for database cleaning strategy.

RSpec.configure do |config|
  config.around do |example|
    Application['database'].transaction(rollback: :always, auto_savepoint: true) { example.run }
  end
end
