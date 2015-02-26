module Riveter
  module Command
    extend ActiveSupport::Concern

    included do
      include Riveter::Attributes

      class << self
        alias_method :command_name, :model_name

        def i18n_scope
          :commands
        end

        def success_notice
          I18n.translate(
            :success,
            :scope => [i18n_scope, :notices, command_name.i18n_key],
            :default => "Successfully executed #{command_name.human}."
          )
        end

        def failure_notice
          I18n.translate(
            :failure,
            :scope => [i18n_scope, :notices, command_name.i18n_key],
            :default => "Failed to execute #{command_name.human}."
          )
        end

        def submit(*args)
          new().submit(*args)
        end
      end

      alias_method :can_perform?, :valid?
    end

    def submit(*args)
      params = args.extract_options!

      # filter and clean params before applying
      apply_params(
        clean_params(
          filter_params(params)
        )
      )

      # perform validations, and proceed if valid
      return false unless self.can_perform?

      # all good, perform the action
      self.perform(*args)
    end

  protected

    def perform(*args)
      # resolve for the registered service for this command
      service_class = Service::Base.resolve!(self.class)
      # create an instance and invoke perform
      service = service_class.new()
      service.perform(self, *args)
    end

    # helper class
    class Base
      include Command
    end
  end
end
