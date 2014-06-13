require 'spec_helper'

shared_examples_for "an attribute" do |type, default_value, *args, &block|
  options = args.extract_options!

  # override these in "calling" specs
  let(:assigned_value) { default_value }
  let(:expected_value) { assigned_value }

  describe type do
    let(:name) { "a_#{type}" }
    let(:instance) { subject.new() }

    describe "as attribute" do
      before do
        subject.send :"attr_#{type}", name, *args, options
      end

      it { subject.attributes.should include(name.to_s) }
      it { instance.attributes.should include(name.to_s) }
      it { instance.should respond_to(name)}
      it { instance.should respond_to("#{name}=")}

      it "assigns attribute in initializer" do
        a = subject.new(name => assigned_value)
        a.send(name).should eq(expected_value)
        a.attributes[name].should eq(expected_value)
      end

      it "assigns attribute" do
        a = subject.new()
        a.send("#{name}=", assigned_value)
        a.attributes[name].should eq(expected_value)
      end
    end

    describe "as required attribute" do
      before do
        subject.send :"attr_#{type}", name, *args, options.merge(:required => true)
      end

      it { instance.should validate_presence_of(name)}
    end

    describe "with default value" do
      before do
        subject.send :"attr_#{type}", name, *args, options.merge(:default => default_value)
      end

      it { instance.send(name).should eq(default_value)}
    end

    describe "with supplied converter block" do
      let(:mock_block) { Mock::Block.new() }

      before do
        subject.send :"attr_#{type}", name, *args, options.merge(:default => default_value), &mock_block
      end

      it {
        expect(mock_block).to receive(:call).at_least(:once)
        instance.send(name)
      }
    end
  end
end

shared_examples_for "a class with attributes" do |type|

  # it's good enough to see whether the type includes
  # the class methods of the attributes module
  it { type.should be_a(Riveter::Attributes::ClassMethods) }

end
