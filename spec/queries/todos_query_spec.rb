# frozen_string_literal: true

require 'spec_helper'

describe TodosQuery do
  describe '#call' do
    let!(:todo)   { create(:todo)                                            }
    let(:todos)   { described_class.new(dataset: Todo, params: params).call  }
    let(:dataset) { instance_double(Sequel::Postgres::Dataset)               }

    context 'when @params does not have any filters' do
      let(:params) { {} }

      before do
        expect(Todo)
          .to receive(:order)
          .with(Sequel.desc(:created_at))
          .and_return(dataset)

        expect(dataset)
          .to receive(:all)
          .and_return([todo])
      end

      it 'returns whole dataset records' do
        expect(todos).to eq [todo]
      end
    end

    context 'when @params[:search_by_name] is present' do
      let(:params) { { search_by_name: 'milk' } }

      before do
        expect(Todo)
          .to receive(:search_by_name)
          .with(params[:search_by_name])
          .and_return(dataset)

        expect(dataset)
          .to receive(:order)
          .with(Sequel.desc(:created_at))
          .and_return(dataset)

        expect(dataset)
          .to receive(:all)
          .and_return([todo])
      end

      it 'returns filtered todos' do
        expect(todos).to eq [todo]
      end
    end

    context 'when @params[:search_by_description] is present' do
      let(:params) { { search_by_description: 'buy milk' } }

      before do
        expect(Todo)
          .to receive(:search_by_description)
          .with(params[:search_by_description])
          .and_return(dataset)

        expect(dataset)
          .to receive(:order)
          .with(Sequel.desc(:created_at))
          .and_return(dataset)

        expect(dataset)
          .to receive(:all)
          .and_return([todo])
      end

      it 'returns filtered todos' do
        expect(todos).to eq [todo]
      end
    end

    context 'when @params[:sort] and @params[:direction] are present' do
      let(:params) { { sort: 'name', direction: 'asc' } }

      before do
        expect(Todo)
          .to receive(:order)
          .with(Sequel.asc(:name))
          .and_return(dataset)

        expect(dataset)
          .to receive(:all)
          .and_return([todo])
      end

      it 'returns ordered todos' do
        expect(todos).to eq [todo]
      end
    end
  end
end
