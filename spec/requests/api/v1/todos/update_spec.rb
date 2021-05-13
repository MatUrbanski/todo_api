# frozen_string_literal: true

require 'spec_helper'

describe 'PUT /api/v1/todos/:id', type: :request do
  include_examples 'authorization check', 'put', '/api/v1/todos/21c9177e-9497-4c86-945b-7d1097c8865f'

  context 'when Authorization headers contains valid token' do
    let(:token) { access_token(user) }
    let(:user)  { create(:user)      }

    context 'when id is valid' do
      let(:todo) { create(:todo, user: user) }

      before do
        header 'Authorization', token

        put "/api/v1/todos/#{todo.id}", params

        todo.refresh
      end

      context 'when request contains incorrectly formatted params' do
        let(:params) { {} }

        it 'returns 422 HTTP status' do
          expect(response.status).to eq 422
        end

        it 'returns error message in JSON response' do
          expect(json_response).to eq({ 'description' => ['is missing'], 'name' => ['is missing'] })
        end
      end

      context 'when request params are valid' do
        let(:params) { { name: 'Buy cheese.', description: 'Please buy cheese.' } }

        let(:todo_json_response) do
          {
            'id' => todo.id,
            'name' => todo.name,
            'description' => todo.description,
            'created_at' => todo.created_at.iso8601,
            'updated_at' => todo.updated_at.iso8601
          }
        end

        it 'returns 200 HTTP status' do
          expect(response.status).to eq 200
        end

        it 'returns updated todo data in the JSON response' do
          expect(json_response).to eq todo_json_response
        end
      end
    end

    context 'when id is invalid' do
      before do
        header 'Authorization', token

        put '/api/v1/todos/21c9177e-9497-4c86-945b-7d1097c8865f'
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

        put "/api/v1/todos/#{todo.id}"
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
