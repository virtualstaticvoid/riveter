module Riveter
  class BooleanessValidator < ActiveModel::EachValidator
    def initialize(options)
      @allow_nil, @allow_blank = options.delete(:allow_nil), options.delete(:allow_blank)
      super
    end

    def validate_each(record, attribute, value)
      return if (@allow_nil && value.nil?) || (@allow_blank && value.blank?)

      unless [true, false].include?(value)
        record.errors.add(attribute, :booleaness, :value => value)
      end
    end
  end
end

# add compatibility with ActiveModel validates method which
# matches option keys to their validator class
ActiveModel::Validations::BooleanessValidator = Riveter::BooleanessValidator
