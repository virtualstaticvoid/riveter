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
  #   attr_string :name[, options] [do |value|
  #     # optional converter logic
  #     value.to_i
  #   end]
  #
  #   options include:
  #    :required => true|false            # default is false
  #    :default => 'a value' or lambda    # default is nil
  #    :validate => true|false            # default is true
  #
  #   optionally, provide a block which takes one argument and returns the converted value
  #
  #  supported attributes:
  #
  #   attr_string      :attr_name
  #   attr_text        :attr_name
  #   attr_integer     :attr_name
  #   attr_decimal     :attr_name
  #   attr_date        :attr_name
  #   attr_date_range  :attr_name[, :min => <date>, :max => <date>]
  #   attr_time        :attr_name
  #   attr_boolean     :attr_name
  #   attr_enum        :attr_name, <enum_module>
  #   attr_array       :attr_name[, :data_type => :integer]
  #   attr_hash        :attr_name[, :data_type => :integer]
  #
  # optionally, define additional validations and helper methods
  #
<% end -%>

end
<% end -%>
