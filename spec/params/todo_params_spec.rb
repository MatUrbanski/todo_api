# frozen_string_literal: true

require 'spec_helper'

describe TodoParams do
  describe '#call' do
    context 'when params are invalid' do
      before do
        expect(Exceptions::InvalidParamsError)
          .to receive(:new)
          .with(object, I18n.t('invalid_params'))
          .and_return(Exceptions::InvalidParamsError.new(object, I18n.t('invalid_params')))
      end

      context 'when params are blank' do
        let(:params) { {} }

        let(:object) do
          {
            name: ['is missing'],
            description: ['is missing']
          }
        end

        it 'raises InvalidParamsError' do
          expect { described_class.new.permit!(params) }.to raise_error(an_instance_of(Exceptions::InvalidParamsError))
        end
      end
    end

    context 'when params are valid' do
      let(:params) { { name: 'Buy milk.', description: 'Please buy milk.' } }

      it 'returns validated params' do
        expect(described_class.new.permit!(params)).to eq params
      end
    end
  end
end
