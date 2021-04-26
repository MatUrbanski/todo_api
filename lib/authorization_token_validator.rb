# frozen_string_literal: true

# {AuthorizationTokenValidator} validates authorization token that comes in Authorization header.
class AuthorizationTokenValidator
  # @param [String] authorization_token that we need to validate.
  # @param [String] purpose of the message.
  def initialize(authorization_token:, purpose:)
    @authorization_token = authorization_token
    @purpose = purpose
  end

  # It validates the authorization token that from the Authorization header.
  #
  # @return [User] when authorization token is valid.
  #
  # @raise [ActiveSupport::MessageVerifier::InvalidSignature] when user authentication_token is different.
  # @raise [ActiveSupport::MessageVerifier::InvalidSignature] when authorization token is invalid.
  # @raise [ActiveSupport::MessageVerifier::InvalidSignature] when purpose is invalid.
  #
  # @example When authorization token is valid:
  #   AuthorizationTokenValidator.new(authorization_token: 'valid-authorization-token', purpose: :authorization).call
  #
  # @example When authorization token is not valid:
  #   AuthorizationTokenValidator.new(authorization_token: 'invalid-authorization-token', purpose: :authorization).call
  #
  # @example When user authentication_token is invalid:
  #   AuthorizationTokenValidator.new(authorization_token: 'valid-authorization-token', purpose: :authorization).call
  #
  # @example When purpose is invalid:
  #   Authorizationalidator.new(refresh_token: 'valid-authorization-token', purpose: :test).call
  def call
    unless current_user && current_user.authentication_token == data[:authentication_token]
      raise(ActiveSupport::MessageVerifier::InvalidSignature)
    end

    current_user
  end

  private

  # It returns {User} data decoded from the authorization token.
  #
  # @return [Hash] {User} data decoded from the authorization token.
  #
  # @raise [ActiveSupport::MessageVerifier::InvalidSignature] when authorization token is invalid.
  def data
    @data ||= MessageVerifier.decode(message: @authorization_token, purpose: @purpose)
  end

  # It returns {User} found by id in decoded data.
  #
  # @return [User] when id in the decoded data is valid.
  # @return [NilClass] when id in the decoded data is not valid.
  def current_user
    @current_user ||= User.find(id: data[:user_id])
  end
end
