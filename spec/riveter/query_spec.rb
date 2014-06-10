require 'spec_helper'
require 'riveter/spec_helper'

describe Riveter::Query do
  describe "#initialize" do
    it "should call #build_relation" do
      expect_any_instance_of(TestQuery).to receive(:build_relation).with(:filter)
      TestQuery.new(:filter)
    end

    it "should assign the filter" do
      TestQuery.new(:filter).query_filter.should eq(:filter)
    end

    it "should assign the options" do
      TestQuery.new(:filter, :key => :value).options.should eq({:key => :value})
    end

    it "should assign the relation" do
      query = TestQuery.new(nil)
      query.relation.should eq(query.build_relation(:filter))
    end
  end

  describe "#build_relation" do
    it "should raise NotImplementedError if not implemented" do
      klass = Class.new(Riveter::Query::Base)
      expect {
        klass.new(:filter)
      }.to raise_error(NotImplementedError)
    end
  end

  describe "#find_each" do
    it "should enumerate relation" do
      # Note: Array implements `find_each_with_order`
      allow_any_instance_of(TestQuery).to receive(:build_relation) { [1] }
      query = TestQuery.new(nil)
      expect(query.relation).to receive(:find_each_with_order)
      query.find_each {}
    end

    it "should invoke block" do
      block = Mock::Block.new()
      expect(block).to receive(:call).at_least(:once)

      fake_relation = [1]
      allow(fake_relation).to receive(:find_each_with_order) do |*args, &block|
        block.call(*args)
      end
      allow_any_instance_of(TestQuery).to receive(:relation) { fake_relation }

      query = TestQuery.new(nil)
      query.find_each &block
    end
  end

  describe "#has_data?" do
    it "should yield true when data available" do
      allow_any_instance_of(TestQuery).to receive(:relation) { [1] }
      query = TestQuery.new(nil)
      query.has_data?.should be_true
    end

    it "should yield false when no data available" do
      allow_any_instance_of(TestQuery).to receive(:relation) { [] }
      query = TestQuery.new(nil)
      query.has_data?.should be_false
    end
  end

end
