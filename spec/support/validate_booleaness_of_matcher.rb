RSpec::Matchers.define :validate_booleaness_of do |attribute|
  match do |model|
    ValidatorDetector.detect(model, attribute, Riveter::BooleanessValidator)
  end

  failure_message do |actual|
    "expect #{attribute} to validate booleaness of"
  end

  failure_message_when_negated do |actual|
    "expect #{attribute} to not validate booleaness of"
  end

  description do
    "expect #{attribute} to validate booleaness of"
  end
end
