require 'spec_helper'

module Locomotive
  module Adapters
    module Memory

      describe Query do
        let(:entry_1) {{ name: 'foo',  id: 1 }}
        let(:entry_2) {{ name: 'bar',  id: 2 }}
        let(:entry_3) {{ name: 'zone', id: 3 }}
        let(:records) do
          { 1 => entry_1, 2 => entry_2, 3 => entry_3 }
        end
        let(:collection) { :foo }
        let(:dataset) do
          Dataset.new(collection).tap do |dataset|
            dataset.stub records: records
          end
        end

        describe '#limited' do
          specify do
            expect(
              Query.new(dataset) do
                limit(1)
              end.all
            ).to eq([entry_1])
          end
        end

        describe '#order_by' do

          context 'asc' do
            specify do
              expect(
                Query.new(dataset) do
                  order_by('name asc')
                end.all.map(&:id)
              ).to eq([2, 1, 3])
            end
          end

          context 'desc' do
            specify do
              expect(
                Query.new(dataset) do
                  order_by('name desc')
                end.all.map(&:id)
              ).to eq([3, 1, 2])
            end
          end
        end

        describe '#where' do
          specify do
            expect(
              Query.new(dataset) do
                where('name.eq' => 'foo').
                where('id.lt' => 2)
              end.all.map(&:id)
            ).to eq([1])
          end
        end

      end
    end
  end
end
