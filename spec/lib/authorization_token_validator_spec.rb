# frozen_string_literal: true

require 'spec_helper'

describe AuthorizationTokenValidator do
  describe '#call' do
    let(:user) { create(:user) }

    context 'when authorization_token is invalid' do
      let(:token) { 'invalid-token' }

      it 'raises ActiveSupport::MessageVerifier::InvalidSignature' do
        expect { described_class.new(authorization_token: token, purpose: :access_token).call }
          .to raise_error(an_instance_of(ActiveSupport::MessageVerifier::InvalidSignature))
      end
    end

    context 'when authorization_token is valid' do
      let(:token) { access_token(user) }

      it 'returns user object' do
        expect(described_class.new(authorization_token: token, purpose: :access_token).call).to eq user
      end
    end

    context 'when user authentication_token is invalid' do
      let!(:token) { access_token(user) }

      before { user.update(authentication_token: 'test') }

      it 'raises ActiveSupport::MessageVerifier::InvalidSignature' do
        expect { described_class.new(authorization_token: token, purpose: :access_token).call }
          .to raise_error(an_instance_of(ActiveSupport::MessageVerifier::InvalidSignature))
      end
    end

    context 'when purpose is invalid' do
      let(:token) { access_token(user) }

      it 'raises ActiveSupport::MessageVerifier::InvalidSignature' do
        expect { described_class.new(authorization_token: token, purpose: :invalid).call }
          .to raise_error(an_instance_of(ActiveSupport::MessageVerifier::InvalidSignature))
      end
    end

    context 'when user id is invalid' do
      let(:token) { access_token(User.new) }

      it 'raises ActiveSupport::MessageVerifier::InvalidSignature' do
        expect { described_class.new(authorization_token: token, purpose: :access_token).call }
          .to raise_error(an_instance_of(ActiveSupport::MessageVerifier::InvalidSignature))
      end
    end
  end
end
