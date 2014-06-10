class TestModelWithAttributeDefaultValues

  # stub ActiveRecord::Base methods

  def self.after_initialize(method_or_proc)
    @@after_initialize_method_or_proc = method_or_proc
  end

  def initialize(*args)
    args.extract_options!.each do |key, value|
      self.send("#{key}=", value)
    end

    @@after_initialize_method_or_proc.respond_to?(:call) ?
      @@after_initialize_method_or_proc.call(self) :
      send(@@after_initialize_method_or_proc)
  end

  def read_attribute(attrib)
    self.send(attrib)
  end

  def write_attribute(attrib, value)
    self.send("#{attrib}=", value)
  end

  include Riveter::AttributeDefaultValues

end
