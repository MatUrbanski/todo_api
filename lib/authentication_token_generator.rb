# frozen_string_literal: true

# {AuthenticationTokenGenerator} generates unique authentication token for {User}.
module AuthenticationTokenGenerator
  # It generates unique authentication token.
  #
  # @return [String] unique authentication token among all users ({User}).
  #
  # @example Generate unique authentication token:
  #   AuthenticationTokenGenerator.call
  def self.call
    loop do
      random_token = SecureRandom.hex(40)
      break random_token unless User.where(authentication_token: random_token).any?
    end
  end
end
