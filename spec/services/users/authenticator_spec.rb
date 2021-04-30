# frozen_string_literal: true

require 'spec_helper'

describe Users::Authenticator do
  describe '#call' do
    let(:result) { described_class.new(email: email, password: password).call }

    context 'when email and password are valid' do
      let(:user) { create(:user) }

      context 'when user email is passed in downcase format' do
        let(:email)    { user.email }
        let(:password) { 'password' }

        it 'returns properly formatted hash' do
          expect(result).to eq user.reload
        end
      end

      context 'when user email is passed in upcase format' do
        let(:email)    { user.email.upcase }
        let(:password) { 'password'        }

        it 'returns properly formatted hash' do
          expect(result).to eq user
        end
      end
    end

    context 'when email or password is invalid' do
      let(:email)    { 'wrong-email'    }
      let(:password) { 'wrong-password' }

      it 'raise Exceptions::InvalidEmailOrPassword' do
        expect { result }.to raise_error(
          Exceptions::InvalidEmailOrPassword
        )
      end
    end

    context 'when email or password are blank' do
      let(:email)    { nil }
      let(:password) { nil }

      it 'raise Exceptions::InvalidEmailOrPassword' do
        expect { result }.to raise_error(
          Exceptions::InvalidEmailOrPassword
        )
      end
    end
  end
end
