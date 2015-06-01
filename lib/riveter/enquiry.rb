module Riveter
  module Enquiry
    extend ActiveSupport::Concern

    included do
      extend ActiveModel::Naming
      extend ActiveModel::Translation

      class << self
        alias_method :enquiry_name, :model_name

        def i18n_scope
          :enquiries
        end
      end
    end

    module ClassMethods

      def filter_with(query_filter_klass=nil, &block)
        raise "Filter already defined." if self.respond_to?(:query_filter_class)

        unless query_filter_klass
          raise ArgumentError, "Missing block" unless block_given?

          # define an anomymous class derived from QueryFilter
          # which invokes the block given in the classes context
          query_filter_klass = Class.new(QueryFilter::Base)
          query_filter_klass.class_eval(&block)

          # for anonymous classes, need to override the
          # model_name method so that forms etc can work
          enquiry_name = self.enquiry_name
          query_filter_klass.class_eval do
            define_singleton_method :model_name do
              enquiry_name
            end
          end
        end

        define_singleton_method :query_filter_class do
          query_filter_klass
        end

        define_method :query_filter_class do
          query_filter_klass
        end

        define_singleton_method :query_filter_attributes do
          query_filter_klass.attributes
        end
      end

      def query_with(query_klass=nil, &block)
        raise "Query already defined." if self.respond_to?(:query_class)

        unless query_klass
          raise ArgumentError, "Missing block" unless block_given?

          # define an anomymous class derived from Query
          # which delegates to the block given
          query_klass = Class.new(Query::Base)
          query_klass.class_eval do
            define_method :build_relation, &block
            protected :build_relation
          end
        end

        define_singleton_method :query_class do
          query_klass
        end

        define_method :query_class do
          query_klass
        end
      end
    end

    def initialize
      # sanity check
      base_message = "#{self.class.name} enquiry not configured correctly."
      raise "#{base_message} No query filter specified. Use the `filter_with` method to provide the query filter to use." unless self.class.respond_to?(:query_filter_class)
      raise "#{base_message} No query specified. Use the `query_with` method to provide the query to use." unless self.class.respond_to?(:query_class)
    end

    def query_filter
      @query_filter ||= query_filter_class.new()
    end
    alias_method :filter, :query_filter

    def query_filter_attributes
      query_filter_class.attributes
    end

    def submit(*args)
      params = args.extract_options!

      # filter and clean params before applying
      @query_filter = create_query_filter(params)

      # perform validations, and proceed if valid
      return false unless @query_filter.valid?

      # all good...
      @query = create_query(@query_filter)
    end

    attr_reader :query

    def find_each(&block)
      self.query && self.query.find_each(&block)
    end

    def has_data?
      self.query && self.query.has_data?
    end

    def query_results
      self.query ? self.query.relation : nil
    end

  protected

    def create_query_filter(params)
      query_filter_class.new(params)
    end

    def create_query(query_filter)
      query_class.new(query_filter)
    end

    # helper class
    class Base
      include Enquiry
    end
  end
end
