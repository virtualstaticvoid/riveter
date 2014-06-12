module Riveter
  module AssociatedTypeRegistry
    extend ActiveSupport::Concern

    included do
      container = self
      type_registry = TypeRegistry.new()

      define_singleton_method :container do
        container
      end

      define_singleton_method :registry do
        type_registry
      end
    end

    module ClassMethods
      def key_for(type)
        type.is_a?(Symbol) ? type : type.name.underscore.to_sym
      end

      def register_type(type, associated_type, options={})
        options = {
          :key => key_for(associated_type)
        }.merge(options)

        # prevent duplicate registrations
        type_list = container.registry[options[:key]]
        type_list << type unless type_list.include?(type)
      end

      def resolve!(type)
        registered = self.resolve(type)
        raise UnregisteredTypeError.new(type) unless registered
        registered
      end

      def resolve(type)
        self.resolve_all(type).first
      end

      def resolve_all(type)
        container.registry[key_for(type)] || []
      end
    end
  end

  class TypeRegistry < Hash
    def initialize
      super {|h, k| h[k] = []}
    end
  end

  class UnregisteredTypeError < StandardError
    attr_reader :type

    def initialize(type)
      super "Unregistered type '#{type}'"
      @type = type
    end
  end
end
