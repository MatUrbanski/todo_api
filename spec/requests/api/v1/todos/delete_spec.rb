# frozen_string_literal: true

require 'spec_helper'

describe 'DELETE /api/v1/todos/:id', type: :request do
  include_examples 'authorization check', 'delete', '/api/v1/todos/21c9177e-9497-4c86-945b-7d1097c8865f'

  context 'when Authorization headers contains valid token' do
    let(:token) { access_token(user)        }
    let(:user)  { create(:user)             }
    let(:todo)  { create(:todo, user: user) }

    context 'when id is valid' do
      before do
        header 'Authorization', token

        delete "/api/v1/todos/#{todo.id}"
      end

      it 'returns 200 HTTP status' do
        expect(response.status).to eq 200
      end

      it 'returns empty response body' do
        expect(response.body).to eq ''
      end

      it 'deletes todo' do
        expect(Todo.count).to eq 0
      end
    end

    context 'when id is invalid' do
      before do
        header 'Authorization', token

        delete '/api/v1/todos/21c9177e-9497-4c86-945b-7d1097c8865f'
      end

      it 'returns 404 HTTP status' do
        expect(response.status).to eq 404
      end

      it 'returns error message in the JSON response' do
        expect(json_response).to eq({ 'error' => 'Record not found.' })
      end
    end

    context 'when todo belongs to different user' do
      let(:todo) { create(:todo) }

      before do
        header 'Authorization', token

        delete "/api/v1/todos/#{todo.id}"
      end

      it 'returns 404 HTTP status' do
        expect(response.status).to eq 404
      end

      it 'returns error message in the JSON response' do
        expect(json_response).to eq({ 'error' => 'Record not found.' })
      end
    end
  end
end
