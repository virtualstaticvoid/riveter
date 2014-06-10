module Riveter
  module Generators
    class EnquiryControllerGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      check_class_collision :suffix => 'EnquiryController'

      argument :action_name,
               :type => :string,
               :default => 'index',
               :banner => 'action_name'

      def create_enquiry_controller_file
        template 'enquiry_controller.rb', File.join('app/controllers', class_path, "#{file_name}_enquiry_controller.rb")
      end

      def create_module_file
        return if regular_class_path.empty?
        template 'module.rb', File.join('app/controllers', "#{class_path.join('/')}.rb") if behavior == :invoke
      end

      def add_enquiry_route
        route "enquiry :#{class_name.underscore}#{additional_args}"
      end

      hook_for :template_engine
      hook_for :test_framework, :as => :enquiry_controller

      def additional_args
        (action_name == 'index') ? '' : ", :action => :#{action_name}"
      end
    end
  end
end
