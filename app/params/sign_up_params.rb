# frozen_string_literal: true

# {SignUpParams} validates POST /api/v1/sign_up params.
#
# @example When params are valid:
#   SignUpParams.new.permit!(email: "test@user.com", password: "password", password_confirmation: "password_confirmation")
#
# @example When params are invalid:
#   SignUpParams.new.permit!({})
class SignUpParams < ApplicationParams
  # @!method params
  #   It stores rules for validating POST /api/v1/sign_up endpoint params using dry-validation DSL.
  params do
    required(:email).filled(:string).value(format?: Constants::EMAIL_REGEX)
    required(:password).filled(:string)
    required(:password_confirmation).filled(:string)
  end
end
