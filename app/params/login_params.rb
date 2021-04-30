# frozen_string_literal: true

# {LoginParams} validaties POST /api/v1/login params.
#
# @example When params are valid:
#   LoginParams.new.permit!(email: "test@user.com", password: "password")
#
# @example When params are invalid:
#   LoginParams.new.permit!({})
class LoginParams < ApplicationParams
  # @!method params
  #   It stores rules for validating POST /api/v1/login endpoint params using dry-validation DSL.
  params do
    required(:email).filled(:string).value(format?: Constants::EMAIL_REGEX)
    required(:password).filled(:string)
  end
end
