# frozen_string_literal: true

module Users
  # {Users::Authenticator} checks {User} email and password during authentication process.
  class Authenticator
    # @param [String] email
    # @param [String] password
    def initialize(email:, password:)
      @email    = email
      @password = password
    end

    # It checks if user email and password are correct.
    #
    # @return [User] when email and password are valid.
    #
    # @raise [Exceptions::InvalidEmailOrPassword] when email or password is invalid.
    #
    # @example When email or password is invalid:
    #   Users::Authenticator.new(email: "invalid-email", password: "invalid-password").call
    #
    # @example When email or password are valid:
    #   Users::Authenticator.new(email: "user@example.com", password: "password").call
    def call
      user = User.find(email: @email)

      return user if user&.authenticate(@password)

      raise(Exceptions::InvalidEmailOrPassword)
    end
  end
end
