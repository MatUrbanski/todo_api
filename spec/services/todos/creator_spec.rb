# frozen_string_literal: true

require 'spec_helper'

describe Todos::Creator do
  describe '#call' do
    let(:user)   { create(:user)                                                }
    let(:result) { described_class.new(user: user, attributes: attributes).call }

    context 'when attributes are valid' do
      let(:attributes) { { name: 'Buy milk.', description: 'Please buy milk.' } }

      let(:created_todo) do
        Todo.find(
          user: user,
          name: 'Buy milk.',
          description: 'Please buy milk.'
        )
      end

      it 'creates and returns Todo' do
        expect(result).to eq created_todo
      end
    end

    context 'when attributes are invalid' do
      let(:attributes) { {} }

      it 'raise Sequel::ValidationFailed' do
        expect { result }.to raise_error(
          Sequel::ValidationFailed
        )
      end
    end
  end
end
