module Rspec
  module Generators
    class CommandControllerGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      argument :new_action,
               :type => :string,
               :default => 'new',
               :banner => 'new_action'

      argument :create_action,
               :type => :string,
               :default => 'create',
               :banner => 'create_action'

      def create_command_controller_spec
        template 'command_controller_spec.rb', File.join('spec/controllers', class_path, "#{file_name}_command_controller_spec.rb")
      end
    end
  end
end
