# frozen_string_literal: true

require 'spec_helper'

describe 'GET /heartbeat', type: :request do
  before { get('/heartbeat') }

  it 'returns 200 HTTP status' do
    expect(response.status).to eq 200
  end

  it 'returns OK in the response body' do
    expect(response.body).to eq 'OK'
  end
end
