module Riveter
  module CommandController
    extend ActiveSupport::Concern

    # FIXME: provide ability to define more than one command per controller

    included do
      class << self
        #
        # configures the controller for the given command
        #
        # you must provide an `on_success` method and optionally an `on_failure` method which will
        # receive callbacks when the 'create' action is run
        #
        # options supported include:
        #
        #   :as               defines the name of the form used to access the params
        #                     defaults to the name of the command
        #
        #   :new_action       overrides the new action name
        #                     by default it is "new"
        #
        #   :create_action    overrides the create action name
        #                     by default it is "create"
        #
        #   :attributes       the list of permitted attributes for initializing the command instance
        #                     defaults to the attributes defined using the `attr_*` helper methods
        #
        def command_controller_for(command_class, options={})
          raise ArgumentError, "#{command_class.name} does not include #{Command.name} module or inherit from #{Command::Base.name}" unless command_class.ancestors.include?(Command)

          options = {
            :as => command_class.name.underscore.gsub(/_command$/, ''),
            :attributes => command_class.attributes,
            :new_action => :new,
            :create_action => :create
          }.merge(options)

          # define instance methods
          # which provide access to the given
          # command class and the options
          define_method :command_class do
            command_class
          end

          define_method :command_options do
            options
          end

          # define the 'new' and 'create' actions
          class_eval <<-RUBY
            def #{options[:new_action]}
              @command = create_command
            end

            def #{options[:create_action]}
              @command = create_command
              if result = @command.submit(command_params)
                on_success(@command, result)
              else
                self.respond_to?(:on_failure) ? on_failure(@command) : render(:new)
              end
            end
          RUBY

          self.include ActionsAndSupport
        end
      end
    end

    module ActionsAndSupport
      extend ActiveSupport::Concern

      included do
        # define the on success callback
        # method as a placeholder to ensure
        # implementors provide the method in their classes
        def on_success(command, result)
          raise NotImplementedError
        end

        def create_command
          command_class.new()
        end

        def command_params
          params.require(command_options[:as])
            .permit(*command_options[:attributes])
        end
      end
    end
  end
end
