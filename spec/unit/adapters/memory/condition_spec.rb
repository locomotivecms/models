require 'spec_helper'

describe Locomotive::Adapters::Memory::Condition do
  let(:entry)    {{ title: { en: 'Awesome Site' }, content: 'foo' }}
  let(:locale)   { :en }
  let(:field)    { :title }
  let(:operator) { :eq }
  let(:name)     { "#{field}.#{operator}"}
  let(:value)    { 'Awesome Site' }

  subject { Locomotive::Adapters::Memory::Condition.new(name, value, locale) }

  describe '#get_value' do
    context 'i18n' do
      let(:name)  { 'title.eq' }
      let(:value) { 'Awesome Site' }

      context 'single entry' do
        specify('should be match') do
          expect(subject.matches?(entry)).to be_true
        end

        specify('return value') do
          expect(subject.send(:get_value, entry)).to eq(value)
        end
      end
    end
    context 'regular way' do
      let(:name)  { 'content.eq' }
      let(:value) { 'foo' }

      context 'single entry' do
        specify('should be match') do
          expect(subject.matches?(entry)).to be_true
        end

        specify('return value') do
          expect(subject.send(:get_value, entry)).to eq(value)
        end
      end
    end
  end

  describe '#decode_operator_based_on_name' do
    before { subject.send(:decode_operator_based_on_name) }

    context 'with normal value' do
      specify('name should be left part of dot') { expect(subject.name).to eq(field) }
      specify('operator should be right part of dot') { expect(subject.operator).to eq(operator) }
      specify('right_operand should be value') { expect(subject.right_operand).to eq(value) }
    end

    context 'with regex value' do
      let(:value) { /^[a-z]$/ }
      specify('operator should be matchtes') { expect(subject.operator).to eq(:matches) }
    end
  end

  describe '#decode_operator_based_on_name' do
    context 'with unsupported operator' do
      let(:name) { 'domains.unsupported' }
      specify('should be throw Exception') do
        expect do
          subject.send(:decode_operator_based_on_name)
        end.to raise_error Locomotive::Adapters::Memory::Condition::UnsupportedOperator
      end
    end
  end

  describe '#decode_operator_based_on_value' do
    let(:name) { 'domains.==' }
    before do
      subject.send(:decode_operator_based_on_name)
      subject.send(:decode_operator_based_on_value, value)
    end
    context 'with single value' do
      let(:value) { 'sample.example.com' }
      specify('operator should be :==') { expect(subject.operator).to eq(:==) }
    end
    context 'with array of values' do
      let(:value) { ['sample.example.com'] }
      specify('operator should be :in') { expect(subject.operator).to eq(:in) }
    end
  end

  describe '#array_contains?' do
    let(:source) { [1, 2, 3, 4] }
    let(:target) { [1, 2, 3] }
    context 'with target contains in source' do
      specify('should be true') do
        expect(subject.send(:array_contains?, source, target)).to be_true
      end
    end
  end

  describe '#value_in_right_operand?' do
    context 'value contains in right operand' do
      let(:value) { [1, 2, 3, 4] }
      let(:right_operand) { [1, 2, 3] }

      before do
        subject.stub(operator: operator, right_operand: right_operand)
      end

      context 'with operator :in' do
        let(:operator) { :in }
        specify('should return true') do
          expect(subject.send(:value_in_right_operand?, value)).to be_true
        end
      end

      context 'with other operator' do
        let(:operator) { :nin }
        specify('should not return true') do
          expect(subject.send(:value_in_right_operand?, value)).to be_false
        end
      end
    end
  end
end
