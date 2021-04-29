# frozen_string_literal: true

require 'spec_helper'

describe 'POST /api/v1/sign_up', type: :request do
  context 'when request contains incorrectly formatted params' do
    before { post '/api/v1/sign_up' }

    it 'returns 422 HTTP status' do
      expect(response.status).to eq 422
    end

    it 'returns error message in JSON response' do
      expect(json_response).to eq(
        { 'email' => ['is missing'], 'password' => ['is missing'], 'password_confirmation' => ['is missing'] }
      )
    end
  end

  context 'when request params are valid' do
    let(:params) do
      {
        email: 'test@user.com',
        password: 'password',
        password_confirmation: 'password'
      }
    end

    let(:created_user) do
      User.find(email: params[:email])
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

    let(:sign_up_json_response) do
      {
        'user' => {
          'id' => created_user.id,
          'email' => created_user.email,
          'created_at' => created_user.created_at.iso8601,
          'updated_at' => created_user.updated_at.iso8601
        },

        'tokens' => tokens
      }
    end

    before do
      expect(AuthorizationTokensGenerator)
        .to receive(:new)
        .and_return(authorization_tokens_generator)

      expect(authorization_tokens_generator)
        .to receive(:call)
        .and_return(tokens)

      post '/api/v1/sign_up', params
    end

    it 'returns 200 status' do
      expect(response.status).to eq 200
    end

    it 'returns user data with its access and refresh token informations in the JSON response' do
      expect(json_response).to eq sign_up_json_response
    end
  end

  context 'when password does not match password_confirmation' do
    let(:params) do
      {
        email: 'test@user.com',
        password: 'password',
        password_confirmation: 'test'
      }
    end

    before { post '/api/v1/sign_up', params }

    it 'returns 422 HTTP status' do
      expect(response.status).to eq 422
    end

    it 'returns error message in JSON response' do
      expect(json_response).to eq({ 'password' => ["doesn't match confirmation"] })
    end
  end

  context 'when email has already been taken' do
    let(:user) { create(:user) }

    let(:params) do
      {
        email: user.email,
        password: 'password',
        password_confirmation: 'password'
      }
    end

    before { post '/api/v1/sign_up', params }

    it 'returns 422 HTTP status' do
      expect(response.status).to eq 422
    end

    it 'returns error message in JSON response' do
      expect(json_response).to eq({ 'email' => ['is already taken'] })
    end
  end
end
