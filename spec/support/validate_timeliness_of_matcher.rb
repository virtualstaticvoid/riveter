RSpec::Matchers.define :validate_timeliness_of do |attribute|
  match do |model|
    ValidatorDetector.detect(model, attribute, ActiveModel::Validations::TimelinessValidator)
  end

  failure_message_for_should do |actual|
    "expect #{attribute} to validate timeliness of"
  end

  failure_message_for_should_not do |actual|
    "expect #{attribute} to not validate timeliness of"
  end

  description do
    "expect #{attribute} to validate timeliness of"
  end
end
