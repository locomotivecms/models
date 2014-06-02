require 'spec_helper'

module Locomotive
  describe Models do

    include_context 'memory'

    describe '#[]' do
      it 'is a shortcut to the repository' do
        Locomotive::Models[:articles].should be_a Locomotive::Example::ArticlesRepository
      end
    end
  end
end
