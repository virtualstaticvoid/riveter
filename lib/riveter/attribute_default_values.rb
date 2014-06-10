module Riveter
  module AttributeDefaultValues
    extend ActiveSupport::Concern

    included do
      #
      # NB:
      #  defines the container within the scope of this class (or module)
      #  so that the list of attributes with defaults aren't shared across models
      #
      class << self
        def attribute_defaults
          @attribute_defaults ||= {}
        end
      end

      # setup after_initialize callback to set the defaults for listed attributes
      after_initialize :set_defaults
    end

    module ClassMethods
      #
      # defines a default value for the given attribute
      #
      # E.g. default_value_for :active, true
      #
      #      default_value_for :active do
      #        # ... some logic ...
      #      end
      #
      def default_value_for(attribute, value=nil, &block)
        self.attribute_defaults[attribute] = (block_given? ? block : value)
      end

      #
      # defines default values for one or more attributes
      # specify defaults using a hash, where the key is the attribute name
      # and the value is the value or a proc
      #
      # E.g.  default_values :confirmed => true,
      #                      :processed => false,
      #                      :some_other => lambda { ... some logic ... }
      #
      def default_values(*args)
        defaults = args.first.is_a?(Hash) ?
                      args.first :
                      { args.first => args.last }

        defaults.each do |attribute, value_or_proc|
          value_or_proc.respond_to?(:call) ?
            default_value_for(attribute, &value_or_proc) :
            default_value_for(attribute, value_or_proc)
        end
      end
    end

    def set_defaults
      return if self.respond_to?(:persisted?) && self.persisted?
      self.class.attribute_defaults.each do |attribute, value_or_proc|
        value = value_or_proc.respond_to?(:call) ?
          (value_or_proc.call(self) rescue value_or_proc.call) :
          value_or_proc
        send("#{attribute}=", value) if send(attribute).blank?
      end
    end
  end
end
