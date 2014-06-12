module Haml
  module Generators
    class CommandControllerGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      check_class_collision :suffix => 'Command'

      argument :new_action,
               :type => :string,
               :default => 'new',
               :banner => 'new_action'

      argument :command_attributes,
               :type => :array,
               :default => [],
               :banner => "[name[:type[:required]] name[:type[:required]]]"

      def initialize(args, *options)
        super
        parse_command_attributes!
      end

      def create_template_file
        template 'new.html.haml', File.join('app/views', class_path, "#{file_name}_command", "#{new_action}.html.haml")
      end

    protected

      def parse_command_attributes!
        self.command_attributes = (command_attributes || []).map do |attribute|
          # expected in the form "name", "name:type" or "name:type:required"
          parts = attribute.split(':')
          name = parts.first.underscore
          type = ((parts.length > 1) ? parts[1] : 'string')

          additional_options = case type.to_sym
            when :integer, :decimal, :boolean, :date, :time, :datetime
              ", :as => :#{type}"
            when :enum
              ", :collection => #{name.titleize}Enum.collection"
            when :model
              ", :collection => #{name.titleize}.all"
            else
              ''
            end

          OpenStruct.new(
            :name => name,
            :type => type,
            :inject_options => additional_options
          )
        end
      end
    end
  end
end
