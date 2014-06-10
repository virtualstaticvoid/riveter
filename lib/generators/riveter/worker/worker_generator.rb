module Riveter
  module Generators
    class WorkerGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      check_class_collision :suffix => 'Worker'

      def create_worker_file
        template 'worker.rb', File.join('app/workers', class_path, "#{file_name}_worker.rb")
      end

      def create_module_file
        return if regular_class_path.empty?
        template 'module.rb', File.join('app/workers', "#{class_path.join('/')}.rb") if behavior == :invoke
      end

      hook_for :test_framework, :as => :worker
    end
  end
end
