# frozen_string_literal: true

RSpec.shared_examples 'authorization check' do |method, url|
  context 'when Authorization header does not contain token' do
    before { public_send(method, url) }

    include_examples 'unauthorized'
  end

  context 'when Authorization header contains invalid token' do
    before do
      header 'Authorization', 'invalid-authorization-token'

      public_send(method, url)
    end

    include_examples 'unauthorized'
  end

  context 'when user authentication_token is invalid' do
    let(:user) { create(:user) }

    before do
      header 'Authorization', access_token(user)

      user.update(authentication_token: 'test')

      public_send(method, url)
    end

    include_examples 'unauthorized'
  end
end
