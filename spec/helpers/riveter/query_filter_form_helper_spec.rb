require 'spec_helper'
require_relative '../../../app/helpers/riveter/query_filter_form_helper'

describe Riveter::QueryFilterFormHelper do
  subject {
    Class.new().tap do |klass|
      klass.send :include, Riveter::QueryFilterFormHelper
    end.new()
  }

  describe "#query_filter_form_for" do
    it "delegates to default form_for" do
      query_filter = TestQueryFilter.new()
      expect(subject).to receive(:form_for).with(query_filter, :as => 'test', :url => 'test', :method => :get)

      subject.query_filter_form_for(query_filter)
    end

    it "delegates to simple form if available" do
      query_filter = TestQueryFilter.new()
      expect(subject).to receive(:simple_form_for).with(query_filter, :as => 'test', :url => 'test', :method => :get)

      subject.query_filter_form_for(query_filter)
    end
  end
end
