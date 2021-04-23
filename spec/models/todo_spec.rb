# frozen_string_literal: true

require 'spec_helper'

describe Todo, type: :model do
  describe 'name presence validation' do
    let(:user) { build(:todo, name: name) }

    before { user.valid? }

    context 'when is blank' do
      let(:name) { nil }

      it 'adds error to the :name field' do
        expect(user.errors[:name]).to eq ['is not present']
      end
    end

    context 'when is not blank' do
      let(:name) { 'Buy milk.' }

      it 'does not add error to the :name field' do
        expect(user.errors[:name]).to eq nil
      end
    end
  end

  describe 'description presence validation' do
    let(:user) { build(:todo, description: description) }

    before { user.valid? }

    context 'when is blank' do
      let(:description) { nil }

      it 'adds error to the :description field' do
        expect(user.errors[:description]).to eq ['is not present']
      end
    end

    context 'when is not blank' do
      let(:description) { 'Remember to but milk.' }

      it 'does not add error to the :description field' do
        expect(user.errors[:description]).to eq nil
      end
    end
  end

  describe 'user_id presence validation' do
    let(:todo) { build(:todo, user: user) }

    before { todo.valid? }

    context 'when is blank' do
      let(:user) { nil }

      it 'adds error to the :user_id field' do
        expect(todo.errors[:user_id]).to eq ['is not present']
      end
    end

    context 'when is not blank' do
      let(:user) { create(:user) }

      it 'does not add error to the :user_id field' do
        expect(todo.errors[:user_id]).to eq nil
      end
    end
  end

  describe '.search_by_name' do
    let!(:todo) { create(:todo, name: 'Buy milk.') }

    before { create(:todo, name: 'Buy cheese.') }

    it 'filters todos by their name' do
      expect(described_class.search_by_name('milk').all).to eq [todo]
    end
  end

  describe '.search_by_description' do
    let!(:todo) { create(:todo, description: 'Remember to buy milk.') }

    before { create(:todo, description: 'Remember to buy cheese.') }

    it 'filters todos by their description' do
      expect(described_class.search_by_description('milk').all).to eq [todo]
    end
  end
end
