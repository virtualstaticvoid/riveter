module Riveter
  module Attributes
    extend ActiveSupport::Concern

    included do

      include ActiveModel::Conversion
      include ActiveModel::Validations
      include ActiveModel::Validations::Callbacks
      include ActiveModel::ForbiddenAttributesProtection

      # define attributes within the class scope
      # so that they aren't shared between including classes

      mattr_accessor :_attributes_container, :instance_writer => false
      self._attributes_container = Hash.new {|hash, key| hash[key] = {}.with_indifferent_access }

      def self._attributes
        self._attributes_container[self]
      end

      def self.attributes
        self._attributes.keys
      end
    end

    module ClassMethods
      def attr_string(name, options={}, &block)
        options = {
          :validate => true
        }.merge(options)

        converter = block_given? ? block : Converters.converter_for(:string)

        attr_reader_with_converter name, converter, options
        attr_writer name

        add_attr(name, :string, converter, options)
      end

      alias_method :attr_text, :attr_string

      def attr_integer(name, options={}, &block)
        attr_numeric(:integer, name, options, &block)
      end

      def attr_decimal(name, options={}, &block)
        attr_numeric(:decimal, name, options, &block)
      end

      def attr_date(name, options={}, &block)
        attr_date_or_time(:date, name, options, &block)
      end

      def attr_time(name, options={}, &block)
        attr_date_or_time(:time, name, options, &block)
      end

      alias :attr_datetime :attr_time

      def attr_date_range(name, options={}, &block)
        options = {
          :validate => true
        }.merge(options)

        required = (true == options.delete(:required))

        [:min, :max].each do |limit|
          limit_value = options.delete(limit)

          define_method :"#{name}_#{limit}" do
            instance_variable_get("@#{name}_#{limit}") ||
              (limit_value.respond_to?(:call) ? instance_exec(&limit_value) : limit_value)
          end

          # can manually assign the min/max
          define_method :"#{name}_#{limit}=" do |value|
            instance_variable_set("@#{name}_#{limit}", value)
          end

        end

        converter = block_given? ? block : Converters.converter_for(:date)

        # return from and to as range
        define_method name do
          # can't have range starting or ending with nil, so return nil
          send(:"#{name}_from")..send(:"#{name}_to") rescue nil
        end

        define_method :"#{name}=" do |value|
          value ||= nil..nil
          range = value.is_a?(Range) ? value : value..value
          send(:"#{name}_from=", range.first)
          send(:"#{name}_to=", range.last)
        end

        add_attr(name, :date_range, converter, options)

        if options[:validate]

          validate :"#{name}_validation"

          define_method :"#{name}_validation" do
            date_from = send(:"#{name}_from")
            date_to = send(:"#{name}_to")

            errors.add(name, :blank) if
              required && (date_from.blank? || date_to.blank?)

            errors.add(name, :invalid) if
              !(date_from.blank? || date_to.blank?) && (date_from > date_to || date_to < date_from)
          end

        end

        # break down into parts
        [:from, :to].each do |part|
          attr_reader_with_converter :"#{name}_#{part}", converter, options

          define_method :"#{name}_#{part}?" do
            send(:"#{name}_#{part}").present?
          end

          attr_writer :"#{name}_#{part}"

          validates :"#{name}_#{part}",
                    :allow_nil => !required,
                    :timeliness => { :type => :date } if options[:validate]

          add_attr(:"#{name}_#{part}", :date, converter)
        end

        # helper for determining if both from and to dates have been provided
        define_method :"#{name}_present?" do
          date_from = send(:"#{name}_from")
          date_to = send(:"#{name}_to")
          date_from && date_to
        end

      end

      def attr_boolean(name, options={}, &block)
        options = {
          :validate => true
        }.merge(options)

        converter = block_given? ? block : Converters.converter_for(:boolean)

        attr_reader_with_converter name, converter, options
        alias_method "#{name}?", name

        attr_writer name

        add_attr(name, :boolean, converter, options)
      end

      # NB: enum must respond to values
      def attr_enum(name, enum, options={}, &block)
        raise ArgumentError, 'enum' unless enum && enum.respond_to?(:values)

        options = {
          :enum => enum,
          :validate => true
        }.merge(options)

        required = options[:required] == true
        converter = block_given? ? block : Converters.converter_for(:enum, options)

        attr_reader_with_converter name, converter, options

        validates name,
                  :allow_blank => !required,
                  :allow_nil => !required,
                  :inclusion => { :in => enum.values } if options[:validate]

        attr_writer name

        add_attr(name, :enum, converter, options)
      end

      def attr_array(name, options={}, &block)
        options = {
          :data_type => :integer,
          :validate => true
        }.merge(options)
        data_type = options.delete(:data_type)

        converter = block_given? ? block : Converters.converter_for(data_type)

        define_method name do
          array = instance_variable_get("@#{name}") || []
          array.map {|v| converter.call(v, options) }
        end

        attr_writer name

        add_attr(name, :array, converter, options)
      end

      def attr_hash(name, options={}, &block)
        options = {
          :data_type => :integer,
          :validate => true
        }.merge(options)
        data_type = options.delete(:data_type)

        converter = block_given? ? block : Converters.converter_for(data_type)

        define_method name do
          hash = instance_variable_get("@#{name}") || {}
          hash.merge(hash) {|k, v| converter.call(v, options) }
        end

        attr_writer name

        add_attr(name, :hash, converter, options)
      end

      def attr_object(name, options={}, &block)
        options = {
          :validate => true
        }.merge(options)

        converter = block_given? ? block : Converters.converter_for(:object, options)

        attr_reader_with_converter name, converter, options

        attr_writer name

        add_attr(name, :object, converter, options)
      end

      def attr_class(name, classes, options={}, &block)
        options = {
          :validate => true,
          :classes => classes
        }.merge(options)

        required = options[:required] == true
        converter = block_given? ? block : Converters.converter_for(:class, options)

        attr_reader_with_converter name, converter, options

        validates name,
                  :allow_blank => !required,
                  :allow_nil => !required,
                  :inclusion => { :in => classes } if options[:validate]

        attr_writer name

        add_attr(name, :class, converter, options)
      end

    private

      def attr_reader_with_converter(name, converter, options={})
        define_method name do
          converter.call(instance_variable_get("@#{name}"), options)
        end
      end

      def attr_numeric(type, name, options={}, &block)
        options = {
          :validate => true
        }.merge(options)

        required = options[:required] == true
        converter = block_given? ? block : Converters.converter_for(type)

        attr_reader_with_converter name, converter, options

        validates name,
                  :allow_blank => !required,
                  :allow_nil => !required,
                  :numericality => { :only => type } if options[:validate]

        attr_writer name

        add_attr(name, type, converter, options)
      end

      def attr_date_or_time(type, name, options={}, &block)
        options = {
          :validate => true
        }.merge(options)

        required = options[:required] == true
        converter = block_given? ? block : Converters.converter_for(type)

        attr_reader_with_converter name, converter, options

        validates name,
                  :allow_blank => !required,
                  :allow_nil => !required,
                  :timeliness => { :type => type } if options[:validate]

        attr_writer name

        add_attr(name, type, converter, options)
      end

      def add_attr(name, type, converter=nil, options={})
        self._attributes[name] = attribute_info = AttributeInfo.new(self, name, type, converter, options)
        validates name, :presence => true if attribute_info.required?
        attribute_info
      end
    end

    class AttributeInfo < Struct.new(:target, :name, :type, :converter, :options)
      def required?
        @required ||= (options[:required] == true)
      end

      def default
        @default ||= options[:default]
      end

      def default?
        !self.default.nil?
      end

      def evaluate_default(scope)
        default? && default.respond_to?(:call) ? scope.instance_exec(&default) : default
      end
    end

    attr_reader :options

    def initialize(params=nil, options={})
      # assign default values
      self.class._attributes.each do |name, attribute_info|
        next unless attribute_info.default?
        send("#{name}=", attribute_info.evaluate_default(self))
      end

      @options = options.freeze

      # filter and clean params before applying
      apply_params(
        clean_params(
          filter_params(
            sanitize_for_mass_assignment(params)
          )
        )
      ) unless params.nil?
    end

    def attributes(options={})
      self.class._attributes.inject({}) do |list, (key, attribute_info)|
        list[key] = self.send(attribute_info.name)
        list
      end
    end

    alias_method :to_params, :attributes

    # forms use this to determine the HTTP verb
    def persisted?
      false
    end

    def has_attribute?(column)
      self.class._attributes.key?(column)
    end

    # forms use this for getting column meta data
    def column_for_attribute(column)
      attribute_info = self.class._attributes[column]
      OpenStruct.new(
        :name => attribute_info.name,
        :type => attribute_info.type,
        :null => !attribute_info.required?,
        :default => attribute_info.default
      )
    end

  protected

    # only include defined attributes
    def filter_params(params)
      attributes = self.class._attributes
      params.keep_if {|name, value|
        attributes.key?(name)
      }
    end

    # remove blank/nil attributes
    def clean_params(params)
      params.reject { |key, value|
        reject_value?(value)
      }
    end

    # given sanitized params, assign values to instance
    def apply_params(params)
      params.each do |attribute, value|
        assign_attribute(attribute, value)
      end
    end

  private

    def reject_value?(value)
      case value
      when Array
        value.reject! {|v| reject_value?(v) }
        false
      when Hash
        value.reject! {|k, v| reject_value?(v) }
        false
      else
        value.blank? unless value.is_a?(FalseClass)
      end
    end

    def assign_attribute(attribute, value)
      public_send("#{attribute}=", value)

    rescue
      if respond_to?("#{attribute}=")
        raise
      else
        raise UnknownAttributeError.new(self, attribute)
      end
    end

    module Converters

      # supply a built-in converter for the given type
      def self.converter_for(data_type, options={})
        case data_type
        when :string
          lambda {|v, opt| v.to_s }

        when :boolean
          lambda {|v, opt| v.to_b }

        when :integer
          lambda {|v, opt| Integer(v) rescue v }

        when :decimal, :float
          lambda {|v, opt| Float(v) rescue v }

        when :date
          lambda {|v, opt| Date.parse(v) rescue v }

        when :time
          lambda {|v, opt| Time.parse(v) rescue v }

        when :enum
          lambda {|enum, v, opt|
            enum.values.include?(v) ? v : enum.value_for(v)
          }.curry[options[:enum]]

        when :class
          lambda {|models, v, opt|
            models[v] || v
          }.curry[options[:classes].inject({}) {|list, klass| list[klass.name] = klass; list }]

        else # object etc...
          lambda {|v, opt| v }
        end
      end

    end

    # helper class
    class Base
      include Attributes
    end
  end
end
