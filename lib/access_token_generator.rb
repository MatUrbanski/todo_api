# frozen_string_literal: true

# {AccessTokenGenerator} generates access token for {User}.
class AccessTokenGenerator
  # @param [User] user
  def initialize(user:)
    @user = user
  end

  # It generates access token for {User}.
  #
  # @return [String] access token which is valid for 5 minutes.
  #
  # @example Generate access token for {User}:
  #   AccessTokenGenerator.new(user: User.last).call
  def call
    data = { user_id: @user.id, authentication_token: @user.authentication_token }

    MessageVerifier.encode(data: data, expires_at: Time.now + 300, purpose: :access_token)
  end
end
