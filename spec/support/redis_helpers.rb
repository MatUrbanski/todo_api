# frozen_string_literal: true

# {RedisHelpers} module contains helper methods that clean Redis between RSpec examples.
module RedisHelpers
  # It returns Redis client instance.
  def redis
    @redis ||= Application[:redis]
  end

  # It calls with_clean_redis command around RSpec examples.
  def self.included(rspec)
    rspec.around do |example|
      with_clean_redis do
        example.run
      end
    end
  end

  # It cleans Redis using flushall command.
  def with_clean_redis
    redis.flushall
    begin
      yield
    ensure
      redis.flushall
    end
  end
end

RSpec.configure do |config|
  config.include RedisHelpers, type: :throttling
end
