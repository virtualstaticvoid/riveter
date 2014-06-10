module Riveter
  module Query
    extend ActiveSupport::Concern

    attr_reader :query_filter
    attr_reader :options
    attr_reader :relation

    def initialize(query_filter, options={})
      @query_filter = query_filter
      @options = options
      @relation = build_relation(@query_filter)
    end

    # enumerates the resultset in batch mode
    def find_each(&block)
      relation.find_each_with_order(&block) if has_data?
    end

    # override if necessary in derived classes
    def has_data?
      @has_data ||= relation.count() > 0
    end

  protected

    # override in derived classes
    def build_relation(filter)

      #
      # use the given filter to add conditions
      # to produce an ActiveRelation as the query
      #
      # E.g. filter.page #=> Model.all.page(filter.page)
      #

      raise NotImplementedError
    end

    # helper class
    class Base
      include Query
    end
  end
end
