# frozen_string_literal: true

require 'spec_helper'

describe TodosParams do
  describe '#call' do
    context 'when params are invalid' do
      before do
        expect(Exceptions::InvalidParamsError)
          .to receive(:new)
          .with(object, I18n.t('invalid_params'))
          .and_return(Exceptions::InvalidParamsError.new(object, I18n.t('invalid_params')))
      end

      let(:params) do
        {
          direction: 'invalid',
          sort: 'invalid'
        }
      end

      let(:object) do
        {
          direction: ['must be one of: desc, asc'],
          sort: ['must be one of: name, description, created_at, updated_at']
        }
      end

      it 'raises InvalidParamsError' do
        expect { described_class.new.permit!(params) }.to raise_error(an_instance_of(Exceptions::InvalidParamsError))
      end
    end

    context 'when params are valid' do
      let(:params) do
        {
          search_by_name: 'milk',
          search_by_description: 'buy milk',
          sort: 'name',
          direction: 'desc'
        }
      end

      it 'returns validated params' do
        expect(described_class.new.permit!(params)).to eq params
      end
    end
  end
end
