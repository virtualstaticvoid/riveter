module Haml
  module Generators
    class EnquiryControllerGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      check_class_collision :suffix => 'Enquiry'

      argument :action_name,
               :type => :string,
               :default => 'index',
               :banner => 'action_name'

      argument :filter_attributes,
               :type => :array,
               :default => [],
               :banner => "[attribute[:type[:required]] attribute[:type[:required]]]"

      def initialize(args, *options)
        super
        parse_filter_attributes!
      end

      def create_template_file
        template 'index.html.haml', File.join('app/views', class_path, "#{file_name}_enquiry", "#{action_name}.html.haml")
      end

    protected

      def parse_filter_attributes!
        self.filter_attributes = (filter_attributes || []).map do |attribute|
          # expected in the form "name", "name:type" or "name:type:required"
          parts = attribute.split(':')
          name = parts.first.underscore
          type = ((parts.length > 1) ? parts[1] : 'string')

          additional_options = case type.to_sym
            when :integer, :decimal, :boolean, :date, :time, :datetime
              ", :as => :#{type}"
            when :enum
              ", :collection => #{name.titleize}.collection"
            when :model
              ", :collection => #{name.titleize}.all"
            else
              ''
            end

          OpenStruct.new(
            :name => name,
            :type => type,
            :inject_options => additional_options
          )
        end
      end
    end
  end
end
