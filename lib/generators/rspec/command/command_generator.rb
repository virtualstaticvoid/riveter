module Rspec
  module Generators
    class CommandGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      def create_command_spec
        template 'command_spec.rb', File.join('spec/commands', class_path, "#{file_name}_command_spec.rb")
      end
    end
  end
end
