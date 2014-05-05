require 'spec_helper'

describe Locomotive::Models, pending: true do

  subject do Locomotive::Models end

  before do
    Locomotive::Models.configure do |config|
      config.locale = :wk # wookie
    end
  end

  describe '.locale' do
    specify do
      expect(subject.locale).to eq(:wk)
    end

    context '', pending: true do
      specify do
        subject.with_locale(:en) do
          expect(Locomotive::Models.locale).to eq(:en)
        end
        expect(subject.locale).to eq(:wk)
      end
    end
  end
end
