# frozen_string_literal: true

require 'spec_helper'

describe 'POST /api/v1/refresh_token', type: :request do
  let(:user) { create(:user) }

  include_examples 'authorization check', 'post', '/api/v1/refresh_token'

  context 'when Authorization headers contains valid refresh token' do
    let(:update_authentication_token) do
      instance_double(Users::UpdateAuthenticationToken)
    end

    let(:authorization_tokens_generator) do
      instance_double(AuthorizationTokensGenerator)
    end

    let(:tokens) do
      {
        'access_token' => {
          'token' => 'authorization_token',
          'expires_in' => 1800
        },

        'refresh_token' => {
          'token' => 'refresh_token',
          'expires_in' => 3600
        }
      }
    end

    before do
      expect(AuthorizationTokensGenerator)
        .to receive(:new)
        .with(user: user)
        .and_return(authorization_tokens_generator)

      expect(authorization_tokens_generator)
        .to receive(:call)
        .and_return(tokens)

      expect(Users::UpdateAuthenticationToken)
        .to receive(:new)
        .with(user: user)
        .and_return(update_authentication_token)

      expect(update_authentication_token)
        .to receive(:call)

      header 'Authorization', refresh_token(user)

      post '/api/v1/refresh_token'

      user.reload
    end

    it 'returns 200 HTTP status' do
      expect(response.status).to eq 200
    end

    it 'returns new authorization and refresh token in the JSON response' do
      expect(json_response).to eq('tokens' => tokens)
    end
  end

  context 'when Authorization headers contains valid authorization token with invalid purpose' do
    before do
      header 'Authorization', access_token(user)

      post '/api/v1/refresh_token'
    end

    include_examples 'unauthorized'
  end
end
