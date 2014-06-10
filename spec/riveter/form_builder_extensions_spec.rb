require 'spec_helper'
require 'riveter/form_builder_extensions'

describe Riveter::FormBuilderExtensions do
  describe "instance" do
    subject { TestFormBuilder.new }

    describe "#search" do
      it { should respond_to(:search) }

      it "should render a submit HTML element" do
        expect(subject).to receive(:submit)

        subject.search
      end
    end

    describe "#reset" do
      it { should respond_to(:reset) }

      it "should render a submit HTML element" do
        expect(subject).to receive(:submit)

        subject.reset
      end
    end
  end
end
