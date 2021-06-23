# frozen_string_literal: true

require 'spec_helper'

describe DeleteAccountWorker do
  describe '#perform' do
    context 'when user id is valid' do
      let(:todo) { create(:todo) }

      before { described_class.new.perform(todo.user_id) }

      it 'deletes user account' do
        expect(User.count).to eq 0
      end

      it 'deletes user todos' do
        expect(Todo.count).to eq 0
      end
    end

    context 'when user id is invalid' do
      it 'raise Sequel::NoMatchingRow' do
        expect { described_class.new.perform('ed448b15-8a03-4d53-b0d1-52d310c0bfb2') }.to raise_error(
          Sequel::NoMatchingRow
        )
      end
    end
  end
end
