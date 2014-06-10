module ValidatorDetector
  class << self
    def detect(model, attribute, validator_class)
      # a naive implementation based on whether the respective validator
      # is in the list of validators for the given attribute
      # and whether it is "active" based on the `if` and `unless` options

      model._validators[attribute.to_sym].detect do |validator|
        validator.class == validator_class &&
          validator.attributes.include?(attribute) &&
            is_validator_applied?(validator)
      end
    end

    def is_validator_applied?(validator)
      #
      # NOTE: this isn't foolproof, since the logic of the method (or Proc)
      # could depend on the state of the model instance or some other logic
      #

      # NOTE: also doesn't take into account the "on" conditional (I.e. only when creating or updating the model)

      # See http://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-validates

      # determine whether the validator has an :if or :unless applied
      method = validator.options[:if] || validator.options[:unless]

      # next, evaluate the condition to determine whether the validator is active
      #  NOTE: any errors are ignored, and the default therefore is false
      if method.instance_of?(Symbol) || method.instance_of?(String)
        # it's a model method, so evalulate within context
        self.new().instance_eval do
          send(method, self) rescue false
        end

      elsif method.instance_of?(Proc)
        # it's a lambda, so invoke within context
        self.new().instance_eval do
          method.call(self) rescue false
        end

      else
        # default is applied
        true
      end
    end
  end
end
