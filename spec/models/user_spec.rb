# frozen_string_literal: true

require 'spec_helper'

describe User, type: :model do
  describe 'email presence validation' do
    let(:user) { build(:user, email: email) }

    before { user.valid? }

    context 'when is blank' do
      let(:email) { nil }

      it 'adds error to the :email field' do
        expect(user.errors[:email]).to eq ['is not present']
      end
    end

    context 'when is not blank' do
      let(:email) { 'test@user.com' }

      it 'does not add error to the :email field' do
        expect(user.errors[:email]).to eq nil
      end
    end
  end

  describe 'email format validation' do
    let(:user) { build(:user, email: email) }

    before { user.valid? }

    context 'when is invalid' do
      let(:email) { 'invalid-email' }

      it 'adds error to the :email field' do
        expect(user.errors[:email]).to eq ['is invalid']
      end
    end

    context 'when is valid' do
      let(:email) { 'test@user.com' }

      it 'does not add error to the :email field' do
        expect(user.errors[:email]).to eq nil
      end
    end
  end

  describe 'email uniqueness validation' do
    let(:user) { build(:user, email: email) }

    before do
      create(:user, email: 'test@user.com')

      user.valid?
    end

    context 'when user email is unique' do
      let(:email) { 'test_2@user.com' }

      it 'does not add error to the :email field' do
        expect(user.errors[:email]).to eq nil
      end
    end

    context 'when user email is not unique' do
      let(:email) { 'test@user.com' }

      it 'adds error to the :email field' do
        expect(user.errors[:email]).to eq ['is already taken']
      end
    end
  end

  describe 'password validation' do
    let(:user) { build(:user, password: password, password_confirmation: password_confirmation) }

    before { user.valid? }

    context 'when is blank' do
      let(:password)              { nil }
      let(:password_confirmation) { nil }

      it 'adds errors to the :password field' do
        expect(user.errors[:password]).to eq ['is not present']
      end
    end

    context 'when is not blank' do
      let(:password)              { 'password' }
      let(:password_confirmation) { 'password' }

      it 'does not add error to the :email field' do
        expect(user.errors[:password]).to eq nil
      end
    end

    context 'when password does not match confirmation' do
      let(:password)              { 'password' }
      let(:password_confirmation) { 'test' }

      it 'adds error to the :password field' do
        expect(user.errors[:password]).to eq ["doesn't match confirmation"]
      end
    end
  end

  describe 'authentication_token presence validation' do
    let(:user) { build(:user, authentication_token: authentication_token) }

    before { user.valid? }

    context 'when is blank' do
      let(:authentication_token) { nil }

      it 'adds error to the :authentication_token field' do
        expect(user.errors[:authentication_token]).to eq ['is not present']
      end
    end

    context 'when is not blank' do
      let(:authentication_token) { 'test' }

      it 'does not add error to the :authentication_token field' do
        expect(user.errors[:authentication_token]).to eq nil
      end
    end
  end

  describe 'authentication_token uniqueness validation' do
    let(:user) { build(:user, authentication_token: authentication_token) }

    before do
      create(:user, authentication_token: 'test')

      user.valid?
    end

    context 'when user authentication_token is unique' do
      let(:authentication_token) { 'test_2' }

      it 'does not add error to the :authentication_token field' do
        expect(user.errors[:authentication_token]).to eq nil
      end
    end

    context 'when user authentication_token is not unique' do
      let(:authentication_token) { 'test' }

      it 'adds error to the :authentication_token field' do
        expect(user.errors[:authentication_token]).to eq ['is already taken']
      end
    end
  end

  describe '#password=' do
    let(:user) { build(:user, password: 'test') }

    it 'sets password_digest column with hashed user password' do
      expect(user.password_digest).not_to eq 'test'
    end
  end

  describe '#authenticate' do
    let(:user) { create(:user) }

    context 'when password is not valid' do
      it 'returns nil' do
        expect(user.authenticate('test')).to eq nil
      end
    end

    context 'when password is valid' do
      it 'returns User object' do
        expect(user.authenticate('password')).to eq user
      end
    end
  end
end
