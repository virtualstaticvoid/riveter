module Rspec
  module Generators
    class EnumGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      def create_enum_spec
        template 'enum_spec.rb', File.join('spec/enums', class_path, "#{file_name}_enum_spec.rb")
      end
    end
  end
end
