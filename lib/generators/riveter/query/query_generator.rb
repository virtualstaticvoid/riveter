module Riveter
  module Generators
    class QueryGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      check_class_collision :suffix => 'Query'

      def create_query_file
        template 'query.rb', File.join('app/queries', class_path, "#{file_name}_query.rb")
      end

      def create_module_file
        return if regular_class_path.empty?
        template 'module.rb', File.join('app/queries', "#{class_path.join('/')}.rb") if behavior == :invoke
      end

      hook_for :test_framework, :as => :query
    end
  end
end
