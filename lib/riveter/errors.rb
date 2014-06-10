module Riveter
  class UnknownAttributeError < NoMethodError
    attr_reader :instance, :attribute

    def initialize(instance, attribute)
      @instance = instance
      @attribute = attribute.to_s
      super("unknown attribute: #{attribute}")
    end
  end
end
