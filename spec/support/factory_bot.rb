# frozen_string_literal: true

# This file contains configuration for FactoryBot gem.

require 'factory_bot'

# Load all factories defined in spec/factories folder.
FactoryBot.find_definitions

# By default, creating a record will call save! on the instance; since this may not always be ideal,
# you can override that behavior by defining to_create on the factory:
FactoryBot.define do
  to_create(&:save)
end

# Allow factory associations to follow the parent's build strategy.
# Previously, all factory associations were created, regardless of whether the parent was persisted to the database.
FactoryBot.use_parent_strategy = false

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
