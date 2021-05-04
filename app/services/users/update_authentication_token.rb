# frozen_string_literal: true

module Users
  # {Users::UpdateAuthenticationToken} updates {User} authentication_token.
  class UpdateAuthenticationToken
    # @param [User] user
    def initialize(user:)
      @user = user
    end

    # It updates user authentication_token.
    #
    # @return [User] for which authentication_token was updated.
    #
    # @example Update {User} authentication_token:
    #   Users::UpdateAuthenticationToken.new(user: User.last).call
    def call
      @user.update(authentication_token: authentication_token)
    end

    private

    # It generates unique authentication token.
    #
    # @see AuthenticationTokenGenerator
    #
    # @return [String] unique authentication token among all users ({User}).
    def authentication_token
      AuthenticationTokenGenerator.call
    end
  end
end
