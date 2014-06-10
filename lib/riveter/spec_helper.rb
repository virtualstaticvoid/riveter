# helpers for use in testing

module Mock
  class Block
    def to_proc
      lambda { |*args| call(*args) }
    end

    # the call method must be provided by in specs
    # E.g. using `expect(mock_block_instance).to receive(:call)` to assert that the "block" gets called
    def call
      raise NotImplementedError, "Expecting `call` method to have an expectation defined to assert."
    end
  end

  module Valid
    def valid?
      true
    end
  end

  module Invalid
    def valid?
      false
    end
  end

  class ValidCommand < Riveter::Command::Base
    include Valid
  end

  class InvalidCommand < Riveter::Command::Base
    include Invalid
  end

  class ValidQueryFilter < Riveter::QueryFilter::Base
    include Valid
  end

  class InvalidQueryFilter < Riveter::QueryFilter::Base
    include Invalid
  end

  class QueryWithData < Riveter::Query::Base
    def has_data?
      true
    end
  end

  class QueryWithoutData < Riveter::Query::Base
    def has_data?
      false
    end
  end
end
