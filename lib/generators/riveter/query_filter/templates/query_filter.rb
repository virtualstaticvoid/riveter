<% module_namespacing do -%>
class <%= class_name %>QueryFilter < Riveter::QueryFilter::Base
<% if filter_attributes.any? %>
<% filter_attributes.each do |attribute| -%>
  attr_<%= attribute.type %> :<%= attribute.name %><%= attribute.inject_options %>
<% end -%>
<% else -%>

  #
  # define filter attributes
  #
  # E.g.
  #
  #   attr_string :name[, options]
  #
  #   options include:
  #    :required => true|false  # default is false
  #    :default => 'a value'    # default is nil
  #    :validate => true|false  # default is true
  #
  #  supported attributes:
  #
  #   attr_string
  #   attr_text
  #   attr_integer
  #   attr_decimal
  #   attr_date
  #   attr_time
  #   attr_boolean
  #   attr_enum
  #   attr_array
  #   attr_hash
  #   attr_model
  #

  # optionally, define additional validations
<% end -%>

end
<% end -%>