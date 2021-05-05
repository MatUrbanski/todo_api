# frozen_string_literal: true

# {TokensSerializer} is responsible for representing access and refresh token informations.
#
# @example Represent {User} access and refresh token in the JSON format:
#   tokens = { access_token: 'access_token', refresh_token: 'refresh_token' }
#   TokensSerializer.new(tokens: tokens).render
class TokensSerializer < ApplicationSerializer
  # It generates Hash object that contains and authorization and refresh token details.
  #
  # @return [Hash] object that contatins authorization and refresh token details.
  #
  # @example Prepare data before transformation to the JSON format:
  #   tokens = { access_token: 'access_token', refresh_token: 'refresh_token' }
  #   TokensSerializer.new(tokens: tokens).to_json
  def to_json
    {
      tokens: @tokens
    }
  end
end
