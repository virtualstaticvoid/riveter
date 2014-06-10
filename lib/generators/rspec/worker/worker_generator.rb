module Rspec
  module Generators
    class WorkerGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      def create_worker_spec
        template 'worker_spec.rb', File.join('spec/workers', class_path, "#{file_name}_worker_spec.rb")
      end
    end
  end
end
