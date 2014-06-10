module Riveter
  module Presenter
    module Object
      extend ActiveSupport::Concern

      def to_presenter(klass)
        raise ArgumentError, 'klass argument cannot be nil' if klass.nil?
        raise ArgumentError, "#{klass} is not a valid presenter class" unless klass <= Presenter::Base
        klass.new(self)
      end
    end

    module Enumerator
      extend ActiveSupport::Concern

      def with_presenter(klass, &block)
        raise ArgumentError, 'klass argument cannot be nil' if klass.nil?
        raise ArgumentError, "#{klass} is not a valid presenter class" unless klass <= Presenter::Base
        return to_enum(__method__, klass) unless block_given?

        ##
        # some magic!
        # assuming that this method is used within the view
        # the block which is supplied will be in the scope of the view
        # therefore, getting it's binding and evaluating self will
        # get us the view object
        ##
        view = block.binding.eval('self')
        is_a_view = view.is_a?(ActionView::Base)

        self.each do |item|
          yield klass.new(item, (is_a_view ? view : nil))
        end
      end
    end

    class Base < SimpleDelegator
      def item
        __getobj__
      end

      def initialize(item, view=nil)
        super(item)
        @view = view
      end

      def method_missing(method, *args, &block)
        return super if @view.nil?

        if respond_to_without_view?(method)
          super
        elsif @view.respond_to?(method)
          @view.send(method, *args, &block)
        else
          super
        end
      end

      def respond_to_with_view?(method)
        respond_to_without_view?(method) || (!@view.nil? && @view.respond_to?(method))
      end
      alias_method_chain :respond_to?, :view
    end
  end
end

class Object
  include Riveter::Presenter::Object
end

class Enumerator
  include Riveter::Presenter::Enumerator
end
