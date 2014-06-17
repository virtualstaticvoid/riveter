module Riveter
  module EnquiryFormHelper
    def enquiry_form_for(enquiry, options={}, &block)
      enquiry_class_name = enquiry.class.name.underscore
      options = {
        :as => enquiry_class_name.gsub(/_enquiry$/, ''),
        :url => enquiry_class_name.gsub(/_enquiry$/, ''),
        :method => :get
      }.merge(options)

      respond_to?(:simple_form_for) ?
        simple_form_for(enquiry.query_filter, options, &block) :
        form_for(enquiry.query_filter, options, &block)
    end

    def paginate_enquiry(enquiry, options={}, &block)
      paginate(enquiry.query, options, &block) if respond_to?(:paginate)
    end
  end
end
