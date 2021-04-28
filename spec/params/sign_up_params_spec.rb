# frozen_string_literal: true

require 'spec_helper'

describe SignUpParams do
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
            email: ['is missing'],
            password: ['is missing'],
            password_confirmation: ['is missing']
          }
        end

        it 'raises InvalidParamsError' do
          expect { described_class.new.permit!(params) }
            .to raise_error(an_instance_of(Exceptions::InvalidParamsError))
        end
      end

      context 'when email has invalid format' do
        let(:params) do
          {
            password: 'password',
            password_confirmation: 'password',
            email: 'invalid-email'
          }
        end

        let(:object) do
          {
            email: ['is in invalid format']
          }
        end

        it 'raises InvalidParamsError' do
          expect { described_class.new.permit!(params) }
            .to raise_error(an_instance_of(Exceptions::InvalidParamsError))
        end
      end
    end

    context 'when params are valid' do
      let(:params) do
        {
          email: 'test@user.com',
          password: 'password',
          password_confirmation: 'password'
        }
      end

      it 'returns validated params' do
        expect(described_class.new.permit!(params)).to eq params
      end
    end
  end
end
