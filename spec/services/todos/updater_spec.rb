# frozen_string_literal: true

require 'spec_helper'

describe Todos::Updater do
  describe '#call' do
    let(:todo)   { create(:todo)                                                }
    let(:result) { described_class.new(todo: todo, attributes: attributes).call }

    context 'when attributes are valid' do
      let(:attributes) { { name: 'Buy cheese.', description: 'Please buy cheese.' } }

      it 'updates and returns todo' do
        expect(result)
          .to have_attributes(name: attributes[:name], description: attributes[:description])
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
