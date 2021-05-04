# frozen_string_literal: true

require 'spec_helper'

describe Users::UpdateAuthenticationToken do
  describe '#call' do
    let(:authentication_token) { 'test_authentication_token'          }
    let(:user)                 { create(:user)                        }
    let(:result)               { described_class.new(user: user).call }

    before do
      expect(AuthenticationTokenGenerator)
        .to receive(:call)
        .and_return(authentication_token)

      result
    end

    it 'returns user object' do
      expect(result).to eq user
    end

    it 'updates user authentication_token' do
      expect(user.authentication_token).to eq authentication_token
    end
  end
end
