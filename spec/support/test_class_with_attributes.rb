require_relative 'test_model'
require_relative 'test_enum'

class TestClassWithAttributes
  include Riveter::Attributes

  attr_string :string, :default => 'A'
  attr_text :text, :default => 'b'
  attr_integer :integer, :default => 1
  attr_decimal :decimal, :default => 9.998
  attr_date :date, :default => Date.new(2010, 1, 12)
  attr_date_range :date_range, :default => Date.new(2010, 1, 12)..Date.new(2011, 1, 12)
  attr_time :time, :default => Time.new(2010, 1, 12, 14, 56)
  attr_boolean :boolean, :default => true
  attr_enum :enum, TestEnum, :default => TestEnum::Member1
  attr_array :array, :default => [1, 2, 3]
  attr_hash :hash, :default => {:a => :b}
  attr_object :object, :default => 'whatever'

end
