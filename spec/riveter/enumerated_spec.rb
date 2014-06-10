require 'spec_helper'

describe Riveter::Enumerated do
  subject { TestEnum }

  describe "#human" do
    it {
      subject.human.should be_present
    }
  end

  describe "#names" do
    it { subject.names.should eq(%i{Member1 Member2}) }
  end

  describe "#all" do
    it { subject.all.should eq([1, 2]) }
  end

  describe "#name_for" do
    it { subject.name_for(1).should be_present }
  end

  describe "#human_name_for" do
    it { subject.name_for(1).should be_present }
    it { subject.name_for(1).should eq(:Member1) }
  end

  describe "#value_for" do
    it { subject.value_for('Member1').should eq(1) }
    it { subject.value_for(:Member1).should eq(1) }
  end

  describe "#collection" do
    it { subject.collection.should be_present }
    it { subject.collection.length.should eq(2) }
  end

  describe "::All" do
    it { subject::All.should be_present }
    it { subject::All.length.should eq(2) }
  end

  # TODO: scenario for a member value of nil
  # TODO: scenario for a member value of a Class

end
