module Riveter
  module Generators
    class CommandControllerGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      check_class_collision :suffix => 'CommandController'

      argument :new_action,
               :type => :string,
               :default => 'new',
               :banner => 'new_action'

      argument :create_action,
               :type => :string,
               :default => 'create',
               :banner => 'create_action'

      def create_command_controller_file
        template 'command_controller.rb', File.join('app/controllers', class_path, "#{file_name}_command_controller.rb")
      end

      def create_module_file
        return if regular_class_path.empty?
        template 'module.rb', File.join('app/controllers', "#{class_path.join('/')}.rb") if behavior == :invoke
      end

      def add_command_route
        route "command :#{class_name.underscore}#{additional_args}"
      end

      hook_for :template_engine
      hook_for :test_framework, :as => :command_controller

      def additional_args
        ((new_action == 'new') ? '' : ", :new_action => :#{new_action}") +
        ((create_action == 'create') ? '' : ", :create_action => :#{create_action}")
      end
    end
  end
end
