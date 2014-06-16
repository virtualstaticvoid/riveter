require 'spec_helper'
require 'riveter/spec_helper'

describe <%= class_name %>Query do

  context "with data" do
    before do
      # TODO: create fixture data
      FactoryGirl.create_list :<%= class_name.underscore %>, 10
    end

    let(:filter) { double(:filter) }
    subject { <%= class_name %>Query.new(filter) }

    it { subject.relation.should_not be_nil }
    it { subject.has_data?.should be_true }
    it {
      block = Mock::Block.new
      expect(block).to receive(:call).at_least(:once)
      subject.find_each &block
    }

  end

  context "without data" do
    let(:filter) { double(:filter) }
    subject { <%= class_name %>Query.new(filter) }

    it { subject.relation.should_not be_nil }
    it { subject.has_data?.should be_false }
    it {
      block = Mock::Block.new
      expect(block).to_not receive(:call)
      subject.find_each &block
    }

  end

  pending "add some examples to (or delete) #{__FILE__}"

end
