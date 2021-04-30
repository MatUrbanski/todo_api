# frozen_string_literal: true

require 'spec_helper'

describe 'POST /api/v1/login', type: :request do
  context 'when request contains incorrectly formatted params' do
    before { post '/api/v1/login' }

    it 'returns 422 HTTP status' do
      expect(response.status).to eq 422
    end

    it 'returns error message in JSON response' do
      expect(json_response).to eq({ 'email' => ['is missing'], 'password' => ['is missing'] })
    end
  end

  context 'when email or password are invalid' do
    let(:params) { { email: 'wrong@email.com', password: 'wrong-password' } }

    before { post '/api/v1/login', params }

    it 'returns 401 status' do
      expect(response.status).to eq 401
    end

    it 'returns error message in JSON response' do
      expect(json_response).to eq 'error' => 'Invalid email or password.'
    end
  end

  context 'when email and password are valid' do
    let(:user)   { create(:user)                               }
    let(:params) { { email: user.email, password: 'password' } }

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

    let(:login_json_response) do
      {
        'user' => {
          'id' => user.id,
          'email' => user.email,
          'created_at' => user.created_at.iso8601,
          'updated_at' => user.updated_at.iso8601
        },

        'tokens' => tokens
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

      post '/api/v1/login', params
    end

    it 'returns 200 status' do
      expect(response.status).to eq 200
    end

    it 'returns user data with its access and refresh token informations in the JSON response' do
      expect(json_response).to eq login_json_response
    end
  end
end
