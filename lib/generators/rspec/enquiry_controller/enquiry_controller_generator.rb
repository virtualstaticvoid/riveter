module Rspec
  module Generators
    class EnquiryControllerGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      argument :action_name,
               :type => :string,
               :default => 'index',
               :banner => 'action_name'

      def create_enquiry_controller_spec
        template 'enquiry_controller_spec.rb', File.join('spec/controllers', class_path, "#{file_name}_enquiry_controller_spec.rb")
      end
    end
  end
end
