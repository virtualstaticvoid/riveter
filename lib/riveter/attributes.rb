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
      def attr_string(name, options={})
        converter = Converters.converter_for(:string)

        define_method name do
          converter.call instance_variable_get("@#{name}")
        end

        attr_writer name

        add_attr(name, :string, converter, options)
      end

      alias_method :attr_text, :attr_string

      def attr_integer(name, options={})
        options = {
          :validate => true
        }.merge(options)

        required = options[:required] == true
        converter = Converters.converter_for(:integer)

        define_method name do
          converter.call instance_variable_get("@#{name}")
        end

        validates name,
                  :allow_blank => !required,
                  :allow_nil => !required,
                  :numericality => { :only => :integer } if options[:validate]

        attr_writer name

        add_attr(name, :integer, converter, options)
      end

      def attr_decimal(name, options={})
        options = {
          :validate => true
        }.merge(options)

        required = options[:required] == true
        converter = Converters.converter_for(:decimal)

        define_method name do
          converter.call instance_variable_get("@#{name}")
        end

        validates name,
                  :allow_blank => !required,
                  :allow_nil => !required,
                  :numericality => true if options[:validate]

        attr_writer name

        add_attr(name, :decimal, converter, options)
      end

      def attr_date(name, options={})
        options = {
          :validate => true
        }.merge(options)

        required = options[:required] == true
        converter = Converters.converter_for(:date)

        define_method name do
          converter.call instance_variable_get("@#{name}")
        end

        validates name,
                  :allow_blank => !required,
                  :allow_nil => !required,
                  :timeliness => { :type => :date } if options[:validate]

        attr_writer name

        add_attr(name, :date, converter, options)
      end

      def attr_time(name, options={})
        options = {
          :validate => true
        }.merge(options)

        required = options[:required] == true
        converter = Converters.converter_for(:time)

        define_method name do
          converter.call instance_variable_get("@#{name}")
        end

        validates name,
                  :allow_blank => !required,
                  :allow_nil => !required,
                  :timeliness => { :type => :time } if options[:validate]

        attr_writer name

        add_attr(name, :time, converter, options)
      end

      alias :attr_datetime :attr_time

      def attr_boolean(name, options={})
        options = {
          :validate => true
        }.merge(options)

        required = options[:required] == true
        converter = Converters.converter_for(:boolean)

        define_method name do
          converter.call instance_variable_get("@#{name}")
        end

        alias_method "#{name}?", name

        validates name,
                  :allow_blank => !required,
                  :allow_nil => !required,
                  :booleaness => true if options[:validate]

        attr_writer name

        add_attr(name, :boolean, converter, options)
      end

      def attr_enum(name, enum, options={})
        options = {
          :enum => enum,
          :validate => true
        }.merge(options)

        required = options[:required] == true
        converter = Converters.converter_for(:enum, options)

        define_method name do
          converter.call instance_variable_get("@#{name}")
        end

        # helpers
        # TODO: would be nicer to emulate an association

        define_singleton_method "#{name}_enum" do
          enum
        end

        define_singleton_method name.to_s.pluralize do
          enum.collection
        end

        validates name,
                  :allow_blank => !required,
                  :allow_nil => !required,
                  :inclusion => { :in => enum.all } if options[:validate]

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
          (instance_variable_get("@#{name}") || []).map {|item| converter.call(item) }
        end

        attr_writer name

        add_attr(name, :array, converter, options)
      end

      def attr_hash(name, options={})
        converter = Converters.converter_for(:hash, options)

        # FIXME:
        #  * need converter for values?
        #  * assumes the hash values are contiguous?
        #

        attr_accessor name

        add_attr(name, :hash, converter, options)
      end

      def attr_model(name, model, options={})
        options = {
          :model => model
        }.merge(options)
        converter = Converters.converter_for(:model, options)

        # FIXME:
        #  * need converter for values?
        #  * define methods to get the actual model instance?
        #  * assign model instance directly?
        #

        # helpers
        define_singleton_method "#{name}_model" do
          model
        end

        define_method name do
          converter.call instance_variable_get("@#{name}")
        end

        attr_writer name

        add_attr(name, :model, converter, options)
      end

      def attr_object(name, options={})
        converter = Converters.converter_for(:object, options)

        define_method name do
          converter.call instance_variable_get("@#{name}")
        end

        attr_writer name

        add_attr(name, :object, converter, options)
      end

    private

      def add_attr(name, type, converter, options={})
        self._attributes[name] = attribute_info = AttributeInfo.new(name, type, converter, options)
        validates name, :presence => true if attribute_info.required?
        attribute_info
      end
    end

    class AttributeInfo < Struct.new(:name, :type, :converter, :options)

      def required?
        @required ||= (options[:required] == true)
      end

      def default
        @default ||= options[:default]
      end

      def default?
        !self.default.nil?
      end

    end

    attr_reader :options

    def initialize(params=nil, options={})
      # assign default values
      self.class._attributes.each do |name, attribute_info|
        next unless attribute_info.default?
        value = attribute_info.default
        send("#{name}=", value.respond_to?(:call) ? value.call : value)
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
          lambda {|v| v.to_s }

        when :boolean
          lambda {|v| v.to_b }

        when :integer
          lambda {|v| Integer(v) rescue v }

        when :decimal
          lambda {|v| Float(v) rescue v }

        when :hash
          lambda {|v| v.to_hash rescue v }

        when :date
          lambda {|v| Date.parse(v) rescue v }

        when :time
          lambda {|v| Time.parse(v) rescue v }

        when :enum
          lambda {|enum, v|
            if v.blank? || v.nil?
              nil
            else
              # FIXME: assuming enum values are integers!
              v = Integer(v) rescue v
              (v.is_a?(String) || v.is_a?(Symbol)) ? enum.value_for(v) : v.to_i
            end
          }.curry[options[:enum]]

        # FIXME:
        # when :hash
        #   lambda {|v| v }

        when :model
          # FIXME:
          lambda {|model, v|
            # assuming v is an ID
            # model.find(v)
            # FIXME
            v
          }.curry[options[:model]]

        else
          lambda {|v| v }
        end
      end

    end

    # helper class
    class Base
      include Attributes
    end
  end
end
