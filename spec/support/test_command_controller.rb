require 'action_controller'
require_relative 'test_command'

class TestCommandController < ActionController::Base
  include Riveter::CommandController
end

class TestTestCommandController < ActionController::Base
  include Riveter::CommandController

  command_controller_for TestCommand
end
