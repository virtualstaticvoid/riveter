module Riveter
  module Service
    extend ActiveSupport::Concern
    include AssociatedTypeRegistry

    module ClassMethods
      def register_as_handler_for(command_type)
        register_type self, command_type
      end
    end

    # override in derived classes
    def perform(command, *args)

      #
      # use the given command's attributes to perform the action
      #

      raise NotImplementedError
    end

    # helper class
    class Base
      include Service

      class << self
        def inherited(klass)
          #
          # attempt to get the name of the command
          # from the derived classes name and register
          # it as the service handler for that command
          #
          # e.g. CreatePortfolioCommand ==> CreatePortfolioService
          #
          command_type = klass.name.gsub(/Service$/, 'Command').constantize rescue nil
          register_type klass, command_type unless command_type.nil?
        end
      end

      # NOTE: associated commands will be registered on this class!
      # use the respective resolve methods with the Riveter::Service::Base in this case

    end
  end
end
