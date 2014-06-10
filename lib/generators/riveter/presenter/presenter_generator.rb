module Riveter
  module Generators
    class PresenterGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      check_class_collision :suffix => 'Presenter'

      def create_presenter_file
        template 'presenter.rb', File.join('app/presenters', class_path, "#{file_name}_presenter.rb")
      end

      def create_module_file
        return if regular_class_path.empty?
        template 'module.rb', File.join('app/presenters', "#{class_path.join('/')}.rb") if behavior == :invoke
      end

      hook_for :test_framework, :as => :presenter
    end
  end
end
