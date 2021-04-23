# frozen_string_literal: true

# {RefreshTokenGenerator} generates refresh token for {User}.
class RefreshTokenGenerator
  # @param [User] user
  def initialize(user:)
    @user = user
  end

  # It generates refresh token for {User}.
  #
  # @return [String] refresh token which is valid for 15 minutes.
  #
  # @example Generate refresh token for {User}:
  #   Users::RefreshTokenGenerator.new(user: User.last).call
  def call
    data = { user_id: @user.id, authentication_token: @user.authentication_token }

    MessageVerifier.encode(data: data, expires_at: Time.now + 900, purpose: :refresh_token)
  end
end
