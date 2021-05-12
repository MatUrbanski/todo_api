# frozen_string_literal: true

require 'spec_helper'

describe 'POST /api/v1/todos', type: :request do
  include_examples 'authorization check', 'post', '/api/v1/todos'

  context 'when Authorization headers contains valid token' do
    let(:token) { access_token(user) }
    let(:user)  { create(:user)      }

    before do
      header 'Authorization', token

      post '/api/v1/todos', params
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
      let(:params) { { name: 'Buy milk.', description: 'Please buy milk.' } }

      let(:created_todo) do
        Todo.find(
          user: user,
          name: params[:name],
          description: params[:description]
        )
      end

      let(:todo_json_response) do
        {
          'id' => created_todo.id,
          'name' => created_todo.name,
          'description' => created_todo.description,
          'created_at' => created_todo.created_at.iso8601,
          'updated_at' => created_todo.updated_at.iso8601
        }
      end

      it 'returns 200 HTTP status' do
        expect(response.status).to eq 200
      end

      it 'returns todo data in the JSON response' do
        expect(json_response).to eq todo_json_response
      end
    end
  end
end
