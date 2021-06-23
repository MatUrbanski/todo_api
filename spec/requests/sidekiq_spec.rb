# frozen_string_literal: true

require 'spec_helper'

describe 'Sidekiq::Web Dashboard', type: :request do
  before do
    header 'Authorization', "Basic #{::Base64.strict_encode64("#{username}:#{password}")}"

    get '/sidekiq'
  end

  context 'when Authorization header does not include valid username and password' do
    let(:username) { 'invalid-username' }
    let(:password) { 'invalid-password' }

    it 'returns 401 HTTP status' do
      expect(response.status).to eq 401
    end
  end

  context 'when Authorization headers include valid username and password' do
    let(:username) { ENV['SIDEKIQ_USER']     }
    let(:password) { ENV['SIDEKIQ_PASSWORD'] }

    it 'returns 200 HTTP status' do
      expect(response.status).to eq 200
    end
  end
end
