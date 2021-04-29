# frozen_string_literal: true

require 'spec_helper'

describe AuthenticationTokenGenerator do
  describe '.call' do
    let(:token) { described_class.call }
    let(:user)  { create(:user)        }

    it 'returns token' do
      expect(token).not_to be_blank
      expect(token).not_to eq user.authentication_token
    end
  end
end
