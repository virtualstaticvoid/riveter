module Riveter
  class DateRangeValidator < ActiveModel::EachValidator
    def initialize(options={})
      @date_from_attr = options.delete(:date_from_attr)
      @date_to_attr = options.delete(:date_to_attr)

      super
    end

    def validate_each(record, attribute, value)
      # NOTE: validate_each usually isn't called when the value is nil
      #  however it is possible to have a nil..nil range, so check for this
      if value.is_a?(Range) && value.first && value.last
        date_from = value.first
        date_to = value.last
        if date_from > date_to
          record.errors.add(attribute, :date_range)
          record.errors.add(@date_from_attr || :"#{attribute}_from", :date_range_date_from, :date_to => date_to)
          record.errors.add(@date_to_attr || :"#{attribute}_to", :date_range_date_to, :date_from => date_from)
        end
      else
        unless options[:allow_nil] || options[:allow_blank]
          record.errors.add(attribute, :blank)
          record.errors.add(@date_from_attr || :"#{attribute}_from", :blank)
          record.errors.add(@date_to_attr || :"#{attribute}_to", :blank)
        end
      end
    end
  end
end

# add compatibility with ActiveModel validates method which
# matches option keys to their validator class
ActiveModel::Validations::DateRangeValidator = Riveter::DateRangeValidator
