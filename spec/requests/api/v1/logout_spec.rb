# frozen_string_literal: true

require 'spec_helper'

describe 'DELETE /api/v1/logout', type: :request do
  include_examples 'authorization check', 'delete', '/api/v1/logout'

  context 'when Authorization headers contains valid token' do
    let(:user) { create(:user) }

    let(:update_authentication_token) do
      instance_double(Users::UpdateAuthenticationToken)
    end

    before do
      expect(Users::UpdateAuthenticationToken)
        .to receive(:new)
        .with(user: user)
        .and_return(update_authentication_token)

      expect(update_authentication_token)
        .to receive(:call)

      header 'Authorization', access_token(user)

      delete '/api/v1/logout'
    end

    it 'returns 200 HTTP status' do
      expect(response.status).to eq 200
    end

    it 'returns empty response body' do
      expect(response.body).to eq ''
    end
  end
end
