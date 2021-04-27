# frozen_string_literal: true

# {UserSerializer} is responsible for representing {User}
# and their access and refresh token informations.
#
# @example Represent {User} in the JSON format:
#   user   = User.last
#   tokens = { access_token: 'access_token', refresh_token:'refresh_token' }
#   UserSerializer.new(user: user, tokens: tokens).render
class UserSerializer < ApplicationSerializer
  # It generates Hash object that contains {User} details and its access and refresh token informations.
  #
  # @return [Hash] object that contains {User} details and its access and refresh token informations.
  #
  # @example Prepare data before transformation to the JSON format:
  #   user   = User.last
  #   tokens = { access_token: 'access_token', refresh_token:'refresh_token' }
  #   UserSerializer.new(user: user, tokens: tokens).to_json
  def to_json
    {
      user: user,
      tokens: @tokens
    }
  end

  private

  # It returns Hash with {User} attributes
  #
  # @return [Hash] {User} attributes.
  def user
    {
      id: @user.id,
      email: @user.email,
      created_at: @user.created_at,
      updated_at: @user.updated_at
    }
  end
end
