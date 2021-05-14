# frozen_string_literal: true

require 'spec_helper'

describe 'Throttling', type: :throttling do
  describe 'POST requests to /api/v1/login by IP address' do
    before do
      request_count.times do |i|
        # We increment the email address here so we can be sure that it's
        # the IP address and not email address that's being blocked.
        params = { email: "sample#{i}@example.com", password: 'password' }

        post '/api/v1/login', params, 'REMOTE_ADDR' => '1.2.3.4'
      end
    end

    context 'when number of requests is lower than the limit' do
      let(:request_count) { 10 }

      it 'does not change the request status' do
        expect(response.status).not_to eq(429)
      end
    end

    context 'when number of requests is higher than the limit' do
      let(:request_count) { 11 }

      it 'changes the request status to 429' do
        expect(response.status).to eq(429)
      end
    end
  end

  describe 'POST requests to /api/v1/login by email param' do
    before do
      request_count.times do |i|
        # This time we increment the IP address so we can be sure that
        # it's the email address and not the IP address that's being blocked.
        params = { email: 'sample@example.com', password: 'password' }

        post '/api/v1/login', params, 'REMOTE_ADDR' => "1.2.3.#{i}"
      end
    end

    context 'when number of requests is lower than the limit' do
      let(:request_count) { 10 }

      it 'does not change the request status' do
        expect(response.status).not_to eq(429)
      end
    end

    context 'when number of requests is higher than the limit' do
      let(:request_count) { 11 }

      it 'changes the request status to 429' do
        expect(response.status).to eq(429)
      end
    end
  end

  describe 'POST requests to /api/v1/sign_up by IP address' do
    before do
      request_count.times do |i|
        params = { email: "sample#{i}@example.com", password: 'password', password_confirmation: 'password' }

        post '/api/v1/sign_up', params, 'REMOTE_ADDR' => '1.2.3.4'
      end
    end

    context 'when number of requests is lower than the limit' do
      let(:request_count) { 3 }

      it 'does not change the request status' do
        expect(response.status).not_to eq(429)
      end
    end

    context 'when number of requests is higher than the limit' do
      let(:request_count) { 4 }

      it 'changes the request status to 429' do
        expect(response.status).to eq(429)
      end
    end
  end

  describe 'Throttle all requests by IP (60rpm).' do
    before do
      request_count.times do
        get '/api/v1/todos', {}, 'REMOTE_ADDR' => '1.2.3.4'
      end
    end

    context 'when number of requests is lower than the limit' do
      let(:request_count) { 20 }

      it 'does not change the request status' do
        expect(response.status).not_to eq(429)
      end
    end

    context 'when number of requests is higher than the limit' do
      let(:request_count) { 21 }

      it 'changes the request status to 429' do
        expect(response.status).to eq(429)
      end
    end
  end
end
