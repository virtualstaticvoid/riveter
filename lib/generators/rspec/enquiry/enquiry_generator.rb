module Rspec
  module Generators
    class EnquiryGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      def create_enquiry_spec
        template 'enquiry_spec.rb', File.join('spec/enquiries', class_path, "#{file_name}_enquiry_spec.rb")
      end
    end
  end
end
