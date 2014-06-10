module Rspec
  module Generators
    class QueryGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      def create_query_spec
        template 'query_spec.rb', File.join('spec/queries', class_path, "#{file_name}_query_spec.rb")
      end
    end
  end
end
