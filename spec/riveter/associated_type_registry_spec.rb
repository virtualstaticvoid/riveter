require 'spec_helper'

describe Riveter::AssociatedTypeRegistry do
  subject do
    Class.new().class_eval {
      include Riveter::AssociatedTypeRegistry
      self
    }
  end

  describe "#container" do
    it "should be itself" do
      subject.container.should eq(subject)
    end

    let(:derived_class) {
      Class.new(subject).class_eval {
        register_type self, TestAssociatedClass
        self
      }
    }

    it "should be the base class for derived classes" do
      derived_class.container.should eq(subject)
    end
  end

  describe "#key_for" do
    it "yields a key for a symbol" do
      subject.key_for(:key).should eq(:key)
    end

    it "yields a key for a type" do
      subject.key_for(TestAssociatedClass).should eq(:test_associated_class)
    end
  end

  describe "#register_type" do
    it "registers the type for the associated class" do
      expect {
        subject.register_type subject, TestAssociatedClass
      }.to change(subject.registry, :length).by(1)
    end
  end

  describe "#resolve_all" do
    it "should yield an empty array for an unregistered type" do
      subject.resolve_all(Class).should eq([])
    end

    let!(:derived_classes) {
      2.times.collect {
        Class.new(subject).class_eval {
          register_type self, TestAssociatedClass
          self
        }
      }
    }

    it "should yield array of types for a registered type" do
      subject.resolve_all(TestAssociatedClass).should eq(derived_classes)
    end
  end

  describe "#resolve" do
    it "should yield nil for an unregistered type" do
      subject.resolve(Class).should be_nil
    end

    let!(:derived_classes) {
      2.times.collect {
        Class.new(subject).class_eval {
          register_type self, TestAssociatedClass
          self
        }
      }
    }

    it "should yield the first associated type for a registered type" do
      subject.resolve(TestAssociatedClass).should eq(derived_classes.first)
    end
  end

  describe "#resolve!" do
    it "should raise UnregisteredType for an unregistered type" do
      expect {
        subject.resolve!(Class)
      }.to raise_error(Riveter::UnregisteredType)
    end

    it "should include the unknown type in the error" do
      begin
        subject.resolve!(Class)
      rescue Exception => e
        e.type.should eq(Class)
      end
    end

    let!(:derived_class) {
      Class.new(subject).class_eval {
        register_type self, TestAssociatedClass
        self
      }
    }

    it "should not raise UnregisteredType for a registered type" do
      expect {
        subject.resolve!(TestAssociatedClass)
      }.to_not raise_error
    end
  end

  describe "#registry" do
    let!(:first_class) do
      Class.new().class_eval {
        include Riveter::AssociatedTypeRegistry
        self
      }
    end

    let!(:second_class) do
      Class.new().class_eval {
        include Riveter::AssociatedTypeRegistry
        self
      }
    end

    let!(:derived_first_class) do
      Class.new(first_class).class_eval {
        register_type self, TestAssociatedClass
        self
      }
    end

    let!(:derived_second_class) do
      Class.new(second_class).class_eval {
        register_type self, TestAssociatedClass
        self
      }
    end

    describe "each type has an independant registry" do
      it { first_class.registry.should_not eq(second_class.registry) }
      it { derived_first_class.registry.should_not eq(derived_second_class.registry) }
      it { derived_first_class.registry.should eq(first_class.registry) }
      it { derived_second_class.registry.should eq(second_class.registry) }
    end

    describe "registered types" do
      let(:key) { first_class.key_for(TestAssociatedClass) }

      it { first_class.registry.key?(key).should be_true }
      it { second_class.registry.key?(key).should be_true }
      it { derived_first_class.registry.key?(key).should be_true }
      it { derived_second_class.registry.key?(key).should be_true }
    end
  end
end
