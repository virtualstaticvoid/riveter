module Riveter
  module Generators
    class CommandGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      check_class_collision :suffix => 'Command'

      argument :command_attributes,
               :type => :array,
               :default => [],
               :banner => "[name[:type[:required]] name[:type[:required]]]"

      class_option :command_controller, :type => :boolean, :default => true
      hook_for :command_controller, :type => :boolean

      def initialize(args, *options)
        super
        parse_command_attributes!
      end

      def create_command_file
        template 'command.rb', File.join('app/commands', class_path, "#{file_name}_command.rb")
      end

      def create_module_file
        return if regular_class_path.empty?
        template 'module.rb', File.join('app/commands', "#{class_path.join('/')}.rb") if behavior == :invoke
      end

      def create_locale_file
        template 'commands.en.yml', File.join('config/locales', 'commands.en.yml') unless locale_file_exists?
      end

      hook_for :test_framework, :as => :command

    protected

      def parse_command_attributes!
        self.command_attributes = (command_attributes || []).map do |attribute|
          # expected in the form "name", "name:type" or "name:type:required"
          parts = attribute.split(':')
          OpenStruct.new(
            :name => parts.first.underscore,
            :type => ((parts.length > 1) ? parts[1] : 'string'),
            :inject_options => ((parts.length == 3 && parts[2] == 'required') ? ', :required => true' : '')
          )
        end
      end

      def locale_file_exists?
        File.exists?(File.join(destination_root, 'config', 'locales', 'commands.en.yml'))
      end
    end
  end
end
