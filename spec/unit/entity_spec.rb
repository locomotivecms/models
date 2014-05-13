require 'spec_helper'

describe Locomotive::Entity do
  
  class FakeEntity
    include Locomotive::Entity
    attributes :name, :description
  end

  context 'simplest instanciation' do
    subject { FakeEntity.new }
    it { should be_a FakeEntity }
    it { should respond_to :name }
    it { should respond_to :name= }    
  end

  context 'with empty hash' do
    subject { FakeEntity.new({}) }
    it { should be_a FakeEntity }
    its(:name) { should be_nil }
  end

  context 'with hash and data in it' do
    subject { FakeEntity.new({name: 'John'}) }
    it { should be_a FakeEntity }
    its(:name) { should eq 'John' }
    its(:description) { should be_nil }    
  end

end