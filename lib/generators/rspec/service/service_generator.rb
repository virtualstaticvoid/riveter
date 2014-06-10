module Rspec
  module Generators
    class ServiceGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      def create_service_spec
        template 'service_spec.rb', File.join('spec/services', class_path, "#{file_name}_service_spec.rb")
      end
    end
  end
end
