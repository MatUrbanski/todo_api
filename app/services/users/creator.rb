# frozen_string_literal: true

module Users
  # {Users::Creator} creates {User} account.
  class Creator
    # @param [Hash] attributes of the {User}
    def initialize(attributes:)
      @attributes = attributes
    end

    # It creates {User} account based on the passed attributes.
    #
    # @return [User] object when attributes are valid.
    #
    # @raise [Sequel::ValidationFailed] when attributes are not valid
    #
    # @example When attributes are valid:
    #   attributes = {email: 'test@user.com', password: 'test', password_confirmations: 'test'}
    #   Users::Creator.new(user: User.last, attributes: attributes).call
    #
    # @example When attributes are not valid:
    #   Users::Creator.new(attributes: {}).call
    def call
      User.create(
        email: @attributes[:email],
        password: @attributes[:password],
        password_confirmation: @attributes[:password_confirmation],
        authentication_token: authentication_token
      )
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
