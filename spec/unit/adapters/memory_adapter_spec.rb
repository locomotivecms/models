require 'spec_helper'

module Locomotive
  describe Adapters::MemoryAdapter do
    include_context 'memory'

    context 'with no loader' do

      before do fill_articles! end

      it 'gets an empty set of sites' do
        adapter.size(:article).should eq 1
      end

      it '' do
        adapter.find(:article, 1, :en).should be_a(Entities::Article)
      end

    end
  end
end
