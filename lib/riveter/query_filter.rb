module Riveter
  module QueryFilter
    extend ActiveSupport::Concern

    included do
      include Riveter::Attributes

      class << self
        alias_method :filter_name, :model_name

        def i18n_scope
          :query_filters
        end
      end
    end

    # helper class
    class Base
      include QueryFilter
    end
  end
end
