module Riveter
  module Rails
    class Railtie < ::Rails::Railtie
      initializer 'riveter.initialize' do
        require 'riveter/form_builder_extensions'
        require 'riveter/command_routes'
        require 'riveter/enquiry_routes'
      end

      initializer 'riveter.set_autoload_paths', :before => :set_autoload_paths do |app|
        config = app.config

        # add paths to auto load path
        %w{
          commands
          enquiries
          enums
          presenters
          queries
          query_filters
          services
          workers
        }.each do |path|
          config.autoload_paths += %W(#{config.root}/app/#{path})
          config.autoload_paths += %W(#{config.root}/app/#{path}/concerns)
        end
      end

      initializer "riveter.load_services" do |app|
        ActiveSupport.on_load :after_initialize do |app|
          #
          # services need to be loaded manually since they aren't referenced
          # directly and therefore cannot be autoloaded
          #
          # also, when the class is loaded, it registers itself as the service for a command
          #
          Dir[File.join(app.config.root, 'app', 'services', '**/*_service.rb')].each {|file| require file }
        end
      end

      console do
        # TODO
      end

      rake_tasks do
        Dir[File.join(File.dirname(__FILE__), 'tasks/*.rake')].each { |file|  load file }
      end
    end
  end
end
