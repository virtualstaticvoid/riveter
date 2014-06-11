module Riveter
  module Generators
    class EnumGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      check_class_collision :suffix => 'Enum'

      argument :enum_members,
               :type => :array,
               :default => [],
               :banner => "[name[:value] name[:value]]"

      def initialize(args, *options)
        super
        parse_enum_members!
      end

      def create_enum_file
        template 'enum.rb', File.join('app/enums', class_path, "#{file_name}_enum.rb")
      end

      def create_module_file
        return if regular_class_path.empty?
        template 'module.rb', File.join('app/enums', "#{class_path.join('/')}.rb") if behavior == :invoke
      end

      def create_locale_file
        template 'enums.en.yml', File.join('config/locales', 'enums.en.yml') unless locale_file_exists?
      end

      hook_for :test_framework, :as => :enum

    protected

      def parse_enum_members!
        self.enum_members = (enum_members || []).map do |member|
          # expected in the form "name:value" or "name"
          parts = member.split(':')
          OpenStruct.new(
            :name => parts.first.titleize,
            :value => (parts.length > 1 ? parts.last : nil)
          )
        end
      end

      def locale_file_exists?
        File.exists?(File.join(destination_root, 'config', 'locales', 'enums.en.yml'))
      end
    end
  end
end
