require 'spec_helper'

describe Locomotive::Adapters::Memory::Condition do
  let(:name) { 'domains.in' }
  let(:value) { 'sample.example.com' }

  subject { Locomotive::Adapters::Memory::Condition.new(name, value) }

  describe '#process_right_operand' do
    before { subject.send(:process_right_operand) }

    context '' do
      specify { expect(subject.right_operand).to eq(value) }
    end

    context '' do
      let(:value) {{ _slug: 42, url: 'sample.example.com' }}
      specify { expect(subject.right_operand).to eq(42) }
    end

    context '' do
      let(:value) {[{ _slug: 42, url: 'sample.example.com' }]}
      specify { expect(subject.right_operand).to eq([42]) }
    end
  end

  describe '#decode_operator_based_on_name' do
    before { subject.send(:decode_operator_based_on_name) }

    context '' do
      specify { expect(subject.name).to eq(:domains) }
      specify { expect(subject.operator).to eq(:in) }
      specify { expect(subject.right_operand).to eq('sample.example.com') }
    end

    context '' do
      let(:value) { /^[a-z]$/ }
      specify { expect(subject.operator).to eq(:matches) }
    end
  end

  describe '#decode_operator_based_on_value' do
    let(:name) { 'domains.==' }
    context '' do
      let(:value) { 'sample.example.com' }
      before do
        subject.send(:decode_operator_based_on_name)
        subject.send(:decode_operator_based_on_value, value)
      end
      specify { expect(subject.operator).to eq(:==) }
    end
    context '' do
      let(:value) { ['sample.example.com'] }
      before do
        subject.send(:decode_operator_based_on_name)
        subject.send(:decode_operator_based_on_value, value)
      end
      specify { expect(subject.operator).to eq(:in) }
    end
  end

  describe '#array_contains?', pending: true do
    let(:source) { [1, 2, 3] }
    let(:target) { [3, 2, 1] }
    context '' do
      specify do
        expect(subject.send(:array_contains?, source, target)).to be_true
      end
    end
  end
end
