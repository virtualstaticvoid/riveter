module Rspec
  module Generators
    class QueryFilterGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      def create_query_filter_spec
        template 'query_filter_spec.rb', File.join('spec/query_filters', class_path, "#{file_name}_query_filter_spec.rb")
      end
    end
  end
end
