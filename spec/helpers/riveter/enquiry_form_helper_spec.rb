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
end
