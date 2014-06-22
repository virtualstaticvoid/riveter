require 'spec_helper'

describe Riveter::EmailValidator do
  subject { Riveter::EmailValidator }

  describe "#validate_each" do
    def record_for(value)
      record = double()
      allow(record).to receive(:read_attribute_for_validation) { value }
      record
    end

    def errors
      errors = double
      allow(errors).to receive(:add)
      errors
    end

    describe "with defaults" do
      it {
        validator = subject.new(:attributes => [:test])
        record = record_for('not_an_email')
        expect(record).to receive(:errors).and_return(errors)

        validator.validate(record)
      }

      it {
        validator = subject.new(:attributes => [:test])
        record = record_for('some@email.com')
        expect(record).to_not receive(:errors)

        validator.validate(record)
      }
    end

    describe "with allow_nil" do
      it {
        validator = subject.new(:attributes => [:test], :allow_nil => false)
        record = record_for(nil)
        expect(record).to receive(:errors).and_return(errors)

        validator.validate(record)
      }

      it {
        validator = subject.new(:attributes => [:test], :allow_nil => true)
        record = record_for(nil)
        expect(record).to_not receive(:errors)

        validator.validate(record)
      }
    end

    describe "with allow_blank" do
      it {
        validator = subject.new(:attributes => [:test], :allow_blank => false)
        record = record_for('')
        expect(record).to receive(:errors).and_return(errors)

        validator.validate(record)
      }

      it {
        validator = subject.new(:attributes => [:test], :allow_blank => true)
        record = record_for('')
        expect(record).to_not receive(:errors)

        validator.validate(record)
      }
    end
  end
end
