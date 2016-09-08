require 'spec_helper'

describe Riveter::AttributeDefaultValues do
  before do
    TestModelWithAttributeDefaultValues.send :attr_accessor, :prop, :prop1, :prop2
  end

  describe "class" do
    subject { TestModelWithAttributeDefaultValues }

    describe "#default_value_for" do
      it { should respond_to(:default_value_for) }

      it "should register default value for given attribute" do
        subject.default_value_for :prop, :value
        subject.attribute_defaults[:prop].should eq(:value)
      end

      it "should register default value using a proc for given attribute" do
        subject.default_value_for :prop do :value; end
        subject.attribute_defaults[:prop].should be_a(Proc)
      end

      it "should have own registration" do
        expect {
          Class.new.class_eval do |klass|

            # provide mock method for after_initialize
            class << self
              def after_initialize(*args)
              end
            end

            include Riveter::AttributeDefaultValues

            attr_accessor :attr_name
            default_value_for :attr_name, 1

          end
        }.to_not change { subject.attribute_defaults.length }
      end
    end

    describe "#default_values" do
      it { should respond_to(:default_values) }

      it "should register multiple default values for given attributes" do
        subject.default_values :prop1 => :value, :prop2 => :value
        subject.attribute_defaults[:prop1].should eq(:value)
        subject.attribute_defaults[:prop2].should eq(:value)
      end

      it "should register multiple default values using a procs for given attributes" do
        subject.default_values :prop1 => lambda { :value }, :prop2 => lambda { :value }
        subject.attribute_defaults[:prop1].should be_a(Proc)
        subject.attribute_defaults[:prop2].should be_a(Proc)
      end
    end
  end

  describe "instance" do
    before do
      TestModelWithAttributeDefaultValues.default_values :prop1 => :value1, :prop2 => lambda {|*args| :value2 }
    end

    subject { TestModelWithAttributeDefaultValues.new() }

    it { subject.prop1.should eq(:value1) }
    it { subject.prop2.should eq(:value2) }

    it "preserves existing attribute values" do
      instance = TestModelWithAttributeDefaultValues.new(:prop1 => :valueA)
      instance.prop1.should eq(:valueA)
      instance.prop2.should eq(:value2)
    end
  end
end
