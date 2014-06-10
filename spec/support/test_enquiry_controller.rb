require 'action_controller'
require_relative 'test_enquiry'

class TestEnquiryController < ActionController::Base
  include Riveter::EnquiryController
end

class TestTestEnquiryController < ActionController::Base
  include Riveter::EnquiryController

  enquiry_controller_for TestEnquiry
end
