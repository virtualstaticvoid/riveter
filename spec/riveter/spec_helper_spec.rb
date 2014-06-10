require 'spec_helper'
require 'riveter/spec_helper'

describe "Spec Helper" do
  describe Mock::Block do
    it "yields a proc object" do
      Mock::Block.new().to_proc.should be_a(Proc)
    end

    it "the proc invokes the call method" do
      expect_any_instance_of(Mock::Block).to receive(:call).at_least(:once)
      Mock::Block.new().to_proc.call
    end

    it "default call method raises an error" do
      expect {
        Mock::Block.new().call
      }.to raise_error(NotImplementedError)
    end
  end
end
