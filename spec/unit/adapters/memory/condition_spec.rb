require 'spec_helper'

describe Locomotive::Adapters::Memory::Condition do
  let(:name) { 'domains.in' }
  let(:value) { 'sample.example.com' }

  subject { Locomotive::Adapters::Memory::Condition.new(name, value) }

  describe '#get_value' do
    before do subject.stub(name: :sites) end
    context '' do
      let(:entry) {{ sites: { title: 'Awesome Site' }}}
      specify do expect(subject.send(:get_value, entry)).to eq([['title', 'Awesome Site']]) end
    end
    context '' do
      let(:entry) {{ sites: { _slug: 42, title: 'Awesome Site' } }}
      specify do expect(subject.send(:get_value, entry)).to eq(42) end
    end
    context '' do
      let(:entry) {{ sites: [{ _slug: 42, title: 'Awesome Site' }] }}
      specify do expect(subject.send(:get_value, entry)).to eq([42]) end
    end
  end

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

  describe '#array_contains?' do
    let(:source) { [1, 2, 3, 4] }
    let(:target) { [1, 2, 3] }
    context '' do
      specify do
        expect(subject.send(:array_contains?, source, target)).to be_true
      end
    end
  end

  describe '#value_in_right_operand?' do
    let(:value) { [1, 2, 3, 4] }
    let(:right_operand) { [1, 2, 3] }

    before do
      subject.stub(operator: operator, right_operand: right_operand)
    end

    context '' do
      let(:operator) { :in }
      specify do
        expect(subject.send(:value_in_right_operand?, value)).to be_true
      end
    end

    context '' do
      let(:operator) { :nin }
      specify do
        expect(subject.send(:value_in_right_operand?, value)).to be_false
      end
    end

  end
end
