module Riveter
  module Generators
    class EnquiryGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      class_option :enquiry_controller, :type => :boolean, :default => true
      hook_for :enquiry_controller, :type => :boolean

      class_option :query, :type => :boolean, :default => true
      hook_for :query, :type => :boolean

      class_option :query_filter, :type => :boolean, :default => true
      hook_for :query_filter, :type => :boolean

      check_class_collision :suffix => 'Enquiry'

      argument :filter_attributes,
               :type => :array,
               :default => [],
               :banner => "[attribute[:type[:required]] attribute[:type[:required]]]"

      def create_enquiry_file
        template 'enquiry.rb', File.join('app/enquiries', class_path, "#{file_name}_enquiry.rb")
      end

      def create_module_file
        return if regular_class_path.empty?
        template 'module.rb', File.join('app/enquiries', "#{class_path.join('/')}.rb") if behavior == :invoke
      end

      hook_for :test_framework, :as => :enquiry
    end
  end
end
