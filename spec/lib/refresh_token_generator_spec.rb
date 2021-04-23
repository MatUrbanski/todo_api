# frozen_string_literal: true

require 'spec_helper'
require 'timecop'

describe RefreshTokenGenerator do
  describe '#call' do
    let(:user)          { create(:user)   }
    let(:refresh_token) { 'refresh_token' }

    let(:data) do
      { user_id: user.id, authentication_token: user.authentication_token }
    end

    before do
      Timecop.freeze

      expect(MessageVerifier)
        .to receive(:encode)
        .with(data: data, expires_at: Time.now + 900, purpose: :refresh_token)
        .and_return(refresh_token)
    end

    after do
      Timecop.return
    end

    it 'returns refresh token for specified user' do
      expect(described_class.new(user: user).call).to eq refresh_token
    end
  end
end
