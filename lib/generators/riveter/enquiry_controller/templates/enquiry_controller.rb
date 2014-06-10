<% module_namespacing do -%>
class <%= class_name %>EnquiryController < ApplicationController
  include Riveter::EnquiryController

  # register as controller for specified enquiry
  enquiry_controller_for <%= class_name %>Enquiry<%= additional_args %>

end
<% end -%>
