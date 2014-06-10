require 'spec_helper'
require 'riveter/spec_helper'

describe <%= class_name %>Enquiry do

  before do
    # TODO: setup data required to exercise the enquiry
  end

  # This should return the minimal set of attributes required to create a valid <%= class_name %>QueryFilter.
  let(:valid_query_filter_attributes) { {} }

  #
  # NOTE: If this spec fails, then all the following ones will fail too!!!
  #
  it "is configured correctly" do
    expect {
      <%= class_name %>Enquiry.new()
    }.to_not raise_error
  end

  describe "#submit" do
    it "succeeds with valid attributes" do
      subject.submit(valid_query_filter_attributes).should be_true
    end

    it "fails with invalid attributes" do
      allow(subject).to receive(:create_query_filter) { Mock::InvalidQueryFilter.new() }
      subject.submit().should be_false
    end
  end

  describe "#has_data?" do
    it "succeeds with valid attributes" do
      subject.submit(valid_query_filter_attributes)
      subject.has_data?.should be_true
    end

    it "fails with invalid attributes" do
      allow(subject).to receive(:create_query_filter) { Mock::InvalidQueryFilter.new() }
      subject.submit()
      subject.has_data?.should be_false
    end
  end

  describe "#query_results" do
    it "succeeds with valid attributes" do
      subject.submit(valid_query_filter_attributes)
      subject.query_results.should_not be_nil
    end

    it "can be iterated" do
      block = Mock::Block.new()
      expect(block).to receive(:call).any_number_of_times

      subject.submit(valid_query_filter_attributes)
      subject.query_results.each &block
    end

    it "fails with invalid attributes" do
      allow(subject).to receive(:create_query_filter) { Mock::InvalidQueryFilter.new() }
      subject.submit()
      subject.query_results.should be_nil
    end
  end

  pending "add some examples to (or delete) #{__FILE__}"

end
