# frozen_string_literal: true

require 'spec_helper'
require 'timecop'

describe AccessTokenGenerator do
  describe '#call' do
    let(:user)         { create(:user)  }
    let(:access_token) { 'access_token' }

    let(:data) do
      { user_id: user.id, authentication_token: user.authentication_token }
    end

    before do
      Timecop.freeze

      expect(MessageVerifier)
        .to receive(:encode)
        .with(data: data, expires_at: Time.now + 300, purpose: :access_token)
        .and_return(access_token)
    end

    after do
      Timecop.return
    end

    it 'returns access token for specified user' do
      expect(described_class.new(user: user).call).to eq access_token
    end
  end
end
