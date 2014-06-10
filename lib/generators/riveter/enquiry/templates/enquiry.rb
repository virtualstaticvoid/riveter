<% module_namespacing do -%>
class <%= class_name %>Enquiry < Riveter::Enquiry::Base

  # define filter to use
  filter_with <%= class_name %>QueryFilter

  # define query to use
  query_with <%= class_name %>Query

end
<% end -%>
