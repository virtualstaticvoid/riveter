require 'spec_helper'
require 'action_controller'

describe Riveter::CommandController do
  context "when not configured" do
    describe "class" do
      subject { TestCommandController }

      it { should respond_to(:command_controller_for) }
      it { should_not respond_to(:command_class) }
      it { should_not respond_to(:command_options) }
    end

    describe "instance" do
      subject { TestCommandController.new }

      it { should_not respond_to(:new) }
      it { should_not respond_to(:create) }
    end
  end

  context "when configured" do
    describe "class" do
      subject { TestTestCommandController }

      it { should respond_to(:command_controller_for) }
    end

    describe "instance" do
      subject { TestTestCommandController.new }

      it { should respond_to(:command_class) }
      it { should respond_to(:command_options) }
      it { should respond_to(:new) }
      it { should respond_to(:create) }

      describe "#command_class" do
        it { subject.command_class.should eq(TestCommand) }
      end

      describe "#command_options" do
        it { subject.command_options.should have_key(:as) }
        it { subject.command_options.should have_key(:attributes) }

        it { subject.command_options[:as].should eq('test') }
        it { subject.command_options[:attributes].should eq(TestCommand.attributes) }
      end

      describe "controller action" do
        describe "#new" do
          it "assigns @command" do
            subject.new
            subject.send(:eval, '@command').should_not be_nil
          end
        end

        describe "#create" do
          before do
            allow(subject).to receive(:params) { ActionController::Parameters.new({:test => {:name => 'test'}}) }
          end

          it "assigns @command" do
            allow_any_instance_of(TestCommand).to receive(:submit) { true }
            allow(subject).to receive(:on_success) { true }

            subject.create
            subject.send(:eval, '@command').should_not be_nil
          end

          it "assigns attributes" do
            allow_any_instance_of(TestCommand).to receive(:perform) { true }
            allow(subject).to receive(:on_success) { true }

            subject.create
            command = subject.send(:eval, '@command')
            command.name.should eq('test')
          end

          context "for a valid command" do
            before do
              allow_any_instance_of(TestCommand).to receive(:submit) { true }
            end

            it "invokes 'on_success'" do
              expect(subject).to receive(:on_success)
              subject.create
            end

            it "throws exception when 'on_success' not implemented" do
              expect {
                subject.create
              }.to raise_error(NotImplementedError)
            end
          end

          context "for an invalid command" do
            before do
              allow_any_instance_of(TestCommand).to receive(:submit) { false }
              allow(subject).to receive(:render) { true }
            end

            it "invokes 'on_failure' if defined" do
              expect(subject).to receive(:on_failure) {}
              subject.create
            end

            it "re-renders the 'new' template" do
              expect(subject).to receive(:render).with(:new) { false }
              subject.create
            end
          end
        end
      end
    end
  end
end
