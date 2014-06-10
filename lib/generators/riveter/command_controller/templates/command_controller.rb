<% module_namespacing do -%>
class <%= class_name %>CommandController < ApplicationController
  include Riveter::CommandController

  # register as controller for specified command
  command_controller_for <%= class_name %>Command<%= additional_args %>

  def on_success(command, result)
    # TODO: provide path for redirect
    respond_to do |format|
      format.html { redirect_to '/', :notice => <%= class_name %>Command.success_notice }
      format.json { render :status => :completed }
      format.js
    end
  end

end
<% end -%>
