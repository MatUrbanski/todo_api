# frozen_string_literal: true

require 'spec_helper'

describe AuthorizationTokensGenerator do
  describe '#call' do
    let(:user)                     { create(:user)                          }
    let(:access_token_generator)   { instance_double(AccessTokenGenerator)  }
    let(:refresh_token_generator)  { instance_double(RefreshTokenGenerator) }

    let(:data) do
      { user_id: user.id, authentication_token: user.authentication_token }
    end

    let(:tokens) do
      {
        access_token: { expires_in: 300, token: 'access_token' },
        refresh_token: { expires_in: 900, token: 'refresh_token' }
      }
    end

    before do
      expect(AccessTokenGenerator)
        .to receive(:new)
        .with(user: user)
        .and_return(access_token_generator)

      expect(access_token_generator)
        .to receive(:call)
        .and_return('access_token')

      expect(RefreshTokenGenerator)
        .to receive(:new)
        .with(user: user)
        .and_return(refresh_token_generator)

      expect(refresh_token_generator)
        .to receive(:call)
        .and_return('refresh_token')
    end

    it 'returns access and refresh token for specified user' do
      expect(described_class.new(user: user).call).to eq tokens
    end
  end
end
