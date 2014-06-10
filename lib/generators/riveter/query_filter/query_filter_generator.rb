module Riveter
  module Generators
    class QueryFilterGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      check_class_collision :suffix => 'QueryFilter'

      argument :filter_attributes,
               :type => :array,
               :default => [],
               :banner => "[attribute[:type[:required]] attribute[:type[:required]]]"

      def initialize(args, *options)
        super
        parse_filter_attributes!
      end

      def create_query_filter_file
        template 'query_filter.rb', File.join('app/query_filters', class_path, "#{file_name}_query_filter.rb")
      end

      def create_module_file
        return if regular_class_path.empty?
        template 'module.rb', File.join('app/enums', "#{class_path.join('/')}.rb") if behavior == :invoke
      end

      def create_locale_file
        template 'query_filters.en.yml', File.join('config/locales', 'query_filters.en.yml') unless locale_file_exists?
      end

      hook_for :test_framework, :as => :query_filter

    protected

      def parse_filter_attributes!
        self.filter_attributes = (filter_attributes || []).map do |attribute|
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
        File.exists?(File.join(destination_root, 'config', 'locales', 'query_filters.en.yml'))
      end
    end
  end
end
