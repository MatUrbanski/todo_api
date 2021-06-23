# frozen_string_literal: true

require 'spec_helper'

describe 'DELETE /api/v1/delete_account', type: :request do
  include_examples 'authorization check', 'delete', '/api/v1/delete_account'

  context 'when Authorization headers contains valid token' do
    let(:user) { create(:user) }

    before do
      expect(DeleteAccountWorker)
        .to receive(:perform_async)
        .with(user.id)

      header 'Authorization', access_token(user)

      delete '/api/v1/delete_account'
    end

    it 'returns 200 HTTP status' do
      expect(response.status).to eq 200
    end

    it 'returns empty response body' do
      expect(response.body).to eq ''
    end
  end
end
