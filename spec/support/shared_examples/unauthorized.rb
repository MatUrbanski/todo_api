# frozen_string_literal: true

RSpec.shared_examples 'unauthorized' do
  it 'returns 401 HTTP status' do
    expect(response.status).to eq 401
  end

  it 'returns error message in the JSON response' do
    expect(json_response).to eq({ 'error' => 'Invalid authorization token.' })
  end
end
