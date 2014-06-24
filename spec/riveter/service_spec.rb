require 'spec_helper'

describe Riveter::Service do
  describe "class" do
    subject { TestService }

    it "automatically registers as handler for TestCommand" do
      Riveter::Service::Base.resolve(:test_command).should eq(subject)
    end

    describe ".register_as_handler_for" do
      let(:command_class) { TestCommand }

      it { should respond_to(:register_as_handler_for) }

      it "registers as handler for given command" do
        expect(subject).to receive(:register_type).with(subject, command_class)
        subject.register_as_handler_for(command_class)
      end

      it "allows for more than one registration" do
        my_test_command_class = Class.new(Riveter::Command::Base)
        allow(my_test_command_class).to receive(:name) { 'MyTestCommand' } # anonymous classes need a name!

        TestService.register_as_handler_for my_test_command_class
        Riveter::Service::Base.resolve(:my_test_command).should eq(subject)
      end
    end
  end

  describe "instance" do
    subject { TestService.new() }

    describe "#perform" do
      it { should respond_to(:perform) }

      it "should raise NotImplementedError if not implemented" do
        expect {
          subject.perform(nil)
        }.to raise_error(NotImplementedError)
      end

      it "should invoke" do
        expect(subject).to receive(:perform) { true }
        subject.perform(TestCommand.new()).should be_truthy
      end
    end
  end
end
