# frozen_string_literal: true

require 'spec_helper'

describe 'GET /api/v1/todos', type: :request do
  include_examples 'authorization check', 'get', '/api/v1/todos'

  context 'when Authorization headers contains valid token' do
    let(:token) { access_token(user) }
    let(:user)  { create(:user)      }

    context 'when request contains incorrectly formatted params' do
      before do
        header 'Authorization', token

        get '/api/v1/todos', { sort: 'invalid' }
      end

      it 'returns 422 HTTP status' do
        expect(response.status).to eq 422
      end

      it 'returns error message in JSON response' do
        expect(json_response).to eq({ 'sort' => ['must be one of: name, description, created_at, updated_at'] })
      end
    end

    context 'when request params are valid' do
      context 'when there is no todos in the database' do
        let(:todos_json_response) do
          {
            'todos' => []
          }
        end

        before do
          header 'Authorization', token

          get '/api/v1/todos'
        end

        it 'returns 200 HTTP status' do
          expect(response.status).to eq 200
        end

        it 'returns empty array in the reponse body' do
          expect(json_response).to eq todos_json_response
        end
      end

      context 'when there are todos in database' do
        let!(:todo) { create(:todo, user: user) }

        let(:todos_json_response) do
          {
            'todos' => [
              {
                'id' => todo.id,
                'name' => todo.name,
                'description' => todo.description,
                'created_at' => todo.created_at.iso8601,
                'updated_at' => todo.updated_at.iso8601
              }
            ]
          }
        end

        before do
          header 'Authorization', token

          get '/api/v1/todos'
        end

        it 'returns 200 HTTP status' do
          expect(response.status).to eq 200
        end

        it 'returns todos data in JSON reponse' do
          expect(json_response).to eq todos_json_response
        end
      end

      context 'when search params are present' do
        let!(:todo) { create(:todo, name: 'Buy milk.', description: 'Remember to buy milk.', user: user) }

        let(:params) do
          {
            search_by_name: 'milk',
            search_by_description: 'buy milk',
            sort: 'name',
            direction: 'asc'
          }
        end

        let(:todos_json_response) do
          {
            'todos' => [
              {
                'id' => todo.id,
                'name' => todo.name,
                'description' => todo.description,
                'created_at' => todo.created_at.iso8601,
                'updated_at' => todo.updated_at.iso8601
              }
            ]
          }
        end

        before do
          header 'Authorization', token

          get '/api/v1/todos', params
        end

        it 'returns 200 HTTP status' do
          expect(response.status).to eq 200
        end

        it 'returns filtered todos data in JSON reponse' do
          expect(json_response).to eq todos_json_response
        end
      end
    end
  end
end
