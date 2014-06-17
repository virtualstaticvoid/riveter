require 'spec_helper'
require_relative '../../../app/helpers/riveter/enquiry_form_helper'

describe Riveter::EnquiryFormHelper do
  subject {
    Class.new().tap do |klass|
      klass.send :include, Riveter::EnquiryFormHelper
    end.new()
  }

  describe "#enquiry_form_for" do
    it "delegates to default form_for" do
      enquiry = TestEnquiry.new()
      expect(subject).to receive(:form_for).with(enquiry.query_filter, :as => 'test', :url => 'test', :method => :get)

      subject.enquiry_form_for(enquiry)
    end

    it "delegates to simple form if available" do
      enquiry = TestEnquiry.new()
      expect(subject).to receive(:simple_form_for).with(enquiry.query_filter, :as => 'test', :url => 'test', :method => :get)

      subject.enquiry_form_for(enquiry)
    end
  end

  describe "#paginate_enquiry" do
    it "delegates to paginate if available" do
      enquiry = TestEnquiry.new()
      allow(enquiry).to receive(:query) { :query }

      expect(subject).to receive(:paginate).with(:query, {:a => :b})
      subject.paginate_enquiry(enquiry, {:a => :b})
    end

    it "does nothing unless paginate method exists" do
      enquiry = TestEnquiry.new()

      subject.paginate_enquiry(enquiry).should be_nil
    end
  end
end
