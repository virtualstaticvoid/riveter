require 'spec_helper'
require 'riveter/spec_helper'

describe <%= class_name %>EnquiryController do
  render_views

  # This should return the minimal set of attributes required to create a valid <%= class_name %>QueryFilter.
  let(:valid_query_filter_attributes) { {} }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # <%= class_name %>EnquiryController. Be sure to keep this updated.
  let(:valid_session) { {} }

  describe "GET '<%= action_name %>'" do
    it "assigns the enquiry" do
      get :<%= action_name %>, {}, valid_session
      assigns(:enquiry).should eq(<%= class_name %>Enquiry.new())
    end



  end

  describe "POST '<%= action_name %>'" do


  end

  pending "add some examples to (or delete) #{__FILE__}"

end
