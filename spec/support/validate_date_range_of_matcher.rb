RSpec::Matchers.define :validate_date_range_of do |attribute|
  match do |model|
    ValidatorDetector.detect(model, attribute, Riveter::DateRangeValidator)
  end

  failure_message_for_should do |actual|
    "expect #{attribute} to validate date range of"
  end

  failure_message_for_should_not do |actual|
    "expect #{attribute} to not validate date range of"
  end

  description do
    "expect #{attribute} to validate date range of"
  end
end
