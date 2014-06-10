module Riveter
  module Generators
    class ServiceGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      check_class_collision :suffix => 'Service'

      def create_service_file
        template 'service.rb', File.join('app/services', class_path, "#{file_name}_service.rb")
      end

      def create_module_file
        return if regular_class_path.empty?
        template 'module.rb', File.join('app/services', "#{class_path.join('/')}.rb") if behavior == :invoke
      end

      hook_for :test_framework, :as => :service
    end
  end
end
