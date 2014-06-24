require 'spec_helper'

describe Riveter::DateRangeValidator do
  subject { Riveter::DateRangeValidator }

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
        record = record_for('not_a_date_range')
        expect(record).to receive(:errors).at_least(:once).and_return(errors)

        validator.validate(record)
      }

      it {
        validator = subject.new(:attributes => [:test])
        record = record_for(nil..nil)
        expect(record).to receive(:errors).at_least(:once).and_return(errors)

        validator.validate(record)
      }

      it {
        validator = subject.new(:attributes => [:test])
        record = record_for(Date.new(2010, 1, 1)..Date.new(2011, 1, 1))
        expect(record).to_not receive(:errors)

        validator.validate(record)
      }

      it {
        validator = subject.new(:attributes => [:test])
        record = record_for(Date.new(2012, 1, 1)..Date.new(2011, 1, 1))
        expect(record).to receive(:errors).at_least(:once).and_return(errors)

        validator.validate(record)
      }
    end

    describe "with allow_nil" do
      it {
        validator = subject.new(:attributes => [:test], :allow_nil => false)
        record = record_for(nil)
        expect(record).to receive(:errors).at_least(:once).and_return(errors)

        validator.validate(record)
      }

      it {
        validator = subject.new(:attributes => [:test], :allow_nil => true)
        record = record_for(nil)
        expect(record).to_not receive(:errors)

        validator.validate(record)
      }

      it {
        validator = subject.new(:attributes => [:test], :allow_nil => true)
        record = record_for(nil..nil)
        expect(record).to_not receive(:errors)

        validator.validate(record)
      }
    end

    describe "with allow_blank" do
      it {
        validator = subject.new(:attributes => [:test], :allow_blank => false)
        record = record_for('')
        expect(record).to receive(:errors).at_least(:once).and_return(errors)

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
