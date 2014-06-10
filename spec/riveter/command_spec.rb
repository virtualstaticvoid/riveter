require 'spec_helper'

describe Riveter::Command do
  it_should_behave_like "a class with attributes", TestCommand

  describe "class" do
    subject { TestCommand }

    describe ".command_name" do
      it { should respond_to(:command_name) }
      it { subject.command_name.should be_a(ActiveModel::Name) }
    end

    describe ".i18n_scope" do
      it { should respond_to(:i18n_scope) }
      it { subject.i18n_scope.should eq(:commands) }
    end
  end

  describe "instance" do
    subject { TestCommand.new() }

    describe "#can_perform?" do
      it "should yield false when invalid" do
        subject.can_perform?.should be_false
      end

      it "should yield true when valid" do
        subject.name = 'test'
        subject.can_perform?.should be_true
      end
    end

    describe "#submit" do
      it "should yield false when invalid" do
        subject.submit().should be_false
      end

      it "should yield true when valid" do
        allow(subject).to receive(:perform) { true }

        subject.name = 'test'
        subject.submit().should be_true
      end

      it "should assign attributes" do
        allow(subject).to receive(:perform) { true }

        subject.submit(:name => 'test')
        subject.name.should eq('test')
      end

      it "should not assign unknown attributes" do
        subject.submit(:unknown => 'test')
        subject.name.should be_blank
      end

      it "should invoke associated service" do
        allow(subject).to receive(:valid?) { true }
        expect_any_instance_of(TestService).to receive(:perform) { true }

        subject.submit(:name => 'test')
      end
    end
  end
end
