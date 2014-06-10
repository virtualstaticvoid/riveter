<% module_namespacing do -%>
module <%= class_name %>Enum
<% if enum_members.any? -%>
<% enum_members.each_with_index do |member, index| -%>
  <%= member.name %> = <%= member.value || ((index + 1) * 10) %>
<% end -%>
<% else -%>
  # TODO: define constants for each member of the enumeration
<% end -%>

  # include the enumerated module
  include Riveter::Enumerated

  # NOTE: any constants defined here onwards will be ignored

end
<% end -%>
