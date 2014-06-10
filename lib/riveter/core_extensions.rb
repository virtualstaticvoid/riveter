module Riveter
  module CoreExtensions
    module BooleanSupport
      extend ActiveSupport::Concern

      Booleans = ['yes', 'on', 'true', 'y', '1', 1, true]

      def boolean?
        self.is_a?(TrueClass) || self.is_a?(FalseClass)
      end

      def to_b
        Booleans.include?(self.to_s.downcase)
      end
    end

    module DateExtensions
      extend ActiveSupport::Concern

      def to_utc_ticks
        Time.utc(self.year, self.month, self.day).to_i * 1000
      end

      module ClassMethods
        def system_start_date
          self.new(1970, 1, 1)
        end

        def from_utc_ticks(ticks)
          (DateTime.strptime ticks.to_s, "%Q").to_date
        end
      end
    end

    module ArrayExtensions
      extend ActiveSupport::Concern

      def cumulative_sum
        sum = 0
        self.map {|x| sum += x}
      end

      # pure genious
      def nil_sum(identity = nil, &block)
        if block_given?
          self.inject(identity) {|sum, x|
            ((sum || 0) + (yield(x) || 0)) || sum
          }
        else
          self.inject(identity) {|sum, x|
            ((sum || 0) + (x || 0)) || sum
          }
        end
      end

      # average of a set of numbers
      def average
        self.sum / self.length.to_f
      end

      # variance of a set of numbers
      def variance
        avg = self.average
        self.inject(0.0) {|acc, value| acc + ((value - avg)**2) } / (self.length.to_f - 1)
      end

      # standard deviation of an array of numbers
      def standard_deviation
        Math.sqrt(self.variance)
      end

      # returns a hash of the items, indexed by the given items attribute
      def to_hash_for(&block)
        if block_given?
          self.inject({}) do |hash, record|
            hash[yield(record)] = record
            hash
          end
        else
          self.inject({}) do |hash, record|
            hash[record] = record
            hash
          end
        end
      end

      # rounds each items to the specified number of places
      def round(places)
        self.collect {|x| x.round(places) }
      end

      # make compatible with an ActiveRelation
      def find_each_with_order(&block)
        self.each &block if block_given?
      end

      alias_method :find_each, :find_each_with_order
    end

    module HashExtensions
      #
      # = Hash Recursive Merge
      #
      # Merges a Ruby Hash recursively, Also known as deep merge.
      # Recursive version of Hash#merge and Hash#merge!.
      #
      # Category::    Ruby
      # Package::     Hash
      # Author::      Simone Carletti <weppos@weppos.net>
      # Copyright::   2007-2008 The Authors
      # License::     MIT License
      # Link::        http://www.simonecarletti.com/
      # Source::      http://gist.github.com/gists/6391/
      #
      # Adds the contents of +other_hash+ to +hsh+,
      # merging entries in +hsh+ with duplicate keys with those from +other_hash+.
      #
      # Compared with Hash#merge!, this method supports nested hashes.
      # When both +hsh+ and +other_hash+ contains an entry with the same key,
      # it merges and returns the values from both arrays.
      #
      #    h1 = {"a" => 100, "b" => 200, "c" => {"c1" => 12, "c2" => 14}}
      #    h2 = {"b" => 254, "c" => 300, "c" => {"c1" => 16, "c3" => 94}}
      #    h1.rmerge!(h2)   #=> {"a" => 100, "b" => 254, "c" => {"c1" => 16, "c2" => 14, "c3" => 94}}
      #
      # Simply using Hash#merge! would return
      #
      #    h1.merge!(h2)    #=> {"a" => 100, "b" = >254, "c" => {"c1" => 16, "c3" => 94}}
      #
      def rmerge!(other_hash)
        merge!(other_hash) do |key, oldval, newval|
            oldval.class == self.class ? oldval.rmerge!(newval) : newval
        end
      end

      #
      # Recursive version of Hash#merge
      #
      # Compared with Hash#merge!, this method supports nested hashes.
      # When both +hsh+ and +other_hash+ contains an entry with the same key,
      # it merges and returns the values from both arrays.
      #
      # Compared with Hash#merge, this method provides a different approch
      # for merging nasted hashes.
      # If the value of a given key is an Hash and both +other_hash+ abd +hsh
      # includes the same key, the value is merged instead replaced with
      # +other_hash+ value.
      #
      #    h1 = {"a" => 100, "b" => 200, "c" => {"c1" => 12, "c2" => 14}}
      #    h2 = {"b" => 254, "c" => 300, "c" => {"c1" => 16, "c3" => 94}}
      #    h1.rmerge(h2)    #=> {"a" => 100, "b" => 254, "c" => {"c1" => 16, "c2" => 14, "c3" => 94}}
      #
      # Simply using Hash#merge would return
      #
      #    h1.merge(h2)     #=> {"a" => 100, "b" = >254, "c" => {"c1" => 16, "c3" => 94}}
      #
      def rmerge(other_hash)
        r = {}
        merge(other_hash)  do |key, oldval, newval|
          r[key] = oldval.class == self.class ? oldval.rmerge(newval) : newval
        end
      end
    end

    module ChainedQuerySupport
      extend ActiveSupport::Concern

      # returns a new relation, which is the result of filtering the current
      # relation according to the conditions in the arguments if the given
      # condition is met
      def where?(condition, *args)
        condition ? self.where(*args) : self
      end
    end

    module BatchFinderSupport
      extend ActiveSupport::Concern

      # finds each record in batches while preserving
      # the specified order of the relation
      def find_each_with_order(options={})
        return to_enum(__method__, options) unless block_given?
        find_in_batches_with_order(options) do |records|
          records.each { |record| yield record }
        end
      end

      # finds each record in batches while preserving
      # the specified order of the relation
      # NOTE: any limit() on the query is overridden with the batch size
      def find_in_batches_with_order(options={})
        return to_enum(__method__, options) unless block_given?
        options.assert_valid_keys(:batch_size)

        relation = self

        start = 0
        batch_size = options.delete(:batch_size) || 1000

        relation = relation.limit(batch_size)
        records = relation.offset(start).to_a

        while records.any?
          records_size = records.size

          yield records

          break if records_size < batch_size

          # get the next batch
          start += batch_size
          records = relation.offset(start + 1).to_a
        end
      end
    end
  end
end

# mixin extensions to respective classes

class Object
  include Riveter::CoreExtensions::BooleanSupport
end

class Date
  include Riveter::CoreExtensions::DateExtensions
end

class Array
  include Riveter::CoreExtensions::ArrayExtensions
end

class Hash
  include Riveter::CoreExtensions::HashExtensions
end

class ActiveRecord::Relation
  include Riveter::CoreExtensions::ChainedQuerySupport
  include Riveter::CoreExtensions::BatchFinderSupport
end

module ActiveRecord
  module Querying
    delegate :find_each_with_order, :find_in_batches_with_order, :to => :scoped
  end
end
