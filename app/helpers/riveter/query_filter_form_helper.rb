module Riveter
  module QueryFilterFormHelper
    def query_filter_form_for(query_filter, options={}, &block)
      query_filter_class_name = query_filter.class.name.underscore
      options = {
        :as => query_filter_class_name.gsub(/_query_filter$/, ''),
        :url => query_filter_class_name,
        :method => :get
      }.merge(options)

      respond_to?(:simple_form_for) ?
        simple_form_for(query_filter, options, &block) :
        form_for(query_filter, options, &block)
    end
  end
end
