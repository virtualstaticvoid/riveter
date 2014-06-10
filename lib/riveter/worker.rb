module Riveter
  module Worker
    extend ActiveSupport::Concern

    included do
      # TODO: define mixed in methods
    end

    module ClassMethods
      # TODO: define class methods
    end

    # TODO: define instance methods

    # helper class
    class Base
      include Worker
    end
  end
end
