module Riveter
  class EmailValidator < ActiveModel::EachValidator
    def initialize(options)
      @allow_nil, @allow_blank = options.delete(:allow_nil), options.delete(:allow_blank)
      super
    end

    def validate_each(record, attribute, value)
      return if (@allow_nil && value.nil?) || (@allow_blank && value.blank?)

      unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
        record.errors.add(attribute, :email, :value => value)
      end
    end
  end
end

# add compatibility with ActiveModel validates method which
# matches option keys to their validator class
ActiveModel::Validations::EmailValidator = Riveter::EmailValidator
