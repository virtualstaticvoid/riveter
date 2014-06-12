require 'spec_helper'
require_relative '../../../app/helpers/riveter/command_form_helper'

describe Riveter::CommandFormHelper do
  subject {
    Class.new().tap do |klass|
      klass.send :include, Riveter::CommandFormHelper
    end.new()
  }

  describe "#command_form_for" do
    it "delegates to default form_for" do
      command = TestCommand.new()
      expect(subject).to receive(:form_for).with(command, :as => 'test', :url => 'test')

      subject.command_form_for(command)
    end

    it "delegates to simple form if available" do
      command = TestCommand.new()
      expect(subject).to receive(:simple_form_for).with(command, :as => 'test', :url => 'test')

      subject.command_form_for(command)
    end
  end
end
