module Riveter
  module Enumerated
    extend ActiveSupport::Concern

    included do

      const_names = self.constants(false).freeze
      const_values = const_names.collect {|name| self.const_get(name) }.freeze

      # create hashes for decoding names and values
      const_value_lookup ||= const_names.inject({}) {|list, name|
        list[name] = self.const_get(name)
        list
      }.with_indifferent_access.freeze

      const_name_lookup ||= const_names.inject({}) {|list, name|
        list[self.const_get(name)] = name
        list
      }.freeze

      # define helper methods

      # returns an array of the constant names as symbols
      define_singleton_method :names do
        const_names
      end

      # returns an array of the constant names as symbols
      define_singleton_method :values do
        const_values
      end

      # returns an array of constant values
      define_singleton_method :all do
        const_values
      end

      # given a value, returns the name of the constant as a symbol
      define_singleton_method :name_for do |value|
        const_name_lookup[value]
      end

      # given a name, returns the value of the constant
      # accepts a string or symbol for the constants name
      define_singleton_method :value_for do |name|
        const_value_lookup[name]
      end

      # returns the human name for the given constant name or value
      # it uses the locale to lookup the translation
      # and defaults to the capitalized name of the constant
      define_singleton_method :human_name_for do |name_or_value, options={}|
        const_name = name_or_value.is_a?(Symbol) ?
                      name_or_value :
                      value_for(name_or_value)

        options = {
          :scope => [:enums, self.to_s.underscore],
          :default => const_name.to_s.titleize
        }.merge!(options)

        I18n.translate(const_name, options)
      end

      # defines the "All" constant
      # which is array like object that can be used to loop
      # over the set of constants and provides some helper methods
      self.const_set :All, Enumeration.new(self, const_values)

      # for use within form select inputs
      define_singleton_method :collection do
        self.const_get(:All).collect {|m| [m.human, m.name] }
      end
    end

    module ClassMethods
      def human(options={})
        options = {
          :scope => [:enums, self.to_s.underscore],
          :default => self.name.titleize
        }.merge!(options)

        I18n.translate(:human, options)
      end
    end

    class Enumeration < Array
      attr_reader :enum

      delegate :names, :values, :human, :to => :enum

      def initialize(enum, values)
        @enum = enum
        super(values.collect {|value| Member.new(enum, value) })
      end
    end

    class Member
      attr_reader :name, :value

      def initialize(enum, value)
        @enum = enum
        @name = enum.name_for(value)
        @value = value
      end

      def human(options={})
        @enum.human_name_for(name, options)
      end
    end
  end
end
