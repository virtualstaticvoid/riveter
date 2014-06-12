module Riveter
  class BooleanessValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless [true, false].include?(value)
        record.errors.add(attribute, :booleaness, :value => value)
      end
    end
  end
end

# add compatibility with ActiveModel validates method which
# matches option keys to their validator class
ActiveModel::Validations::BooleanessValidator = Riveter::BooleanessValidator
