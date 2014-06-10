<% module_namespacing do -%>
class <%= class_name %>Command < Riveter::Command::Base
<% if command_attributes.any? %>
<% command_attributes.each do |attribute| -%>
  attr_<%= attribute.type %> :<%= attribute.name %><%= attribute.inject_options %>
<% end -%>
<% else -%>

  #
  # define command attributes
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
<% end -%>

  # optionally, define additional validations

end
<% end -%>
