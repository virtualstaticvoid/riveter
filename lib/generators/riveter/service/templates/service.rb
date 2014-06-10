<% module_namespacing do -%>
class <%= class_name %>Service < Riveter::Service::Base

  # associate this handler with the respective command
  register_as_handler_for <%= class_name %>Command

  def perform(command)
    # TODO: provide implementation
  end

end
<% end -%>
