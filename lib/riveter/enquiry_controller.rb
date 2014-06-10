module Riveter
  module EnquiryController
    extend ActiveSupport::Concern

    # FIXME: provide ability to define more than one enquiry per controller

    included do

      class << self
        #
        # configures the controller for the given enquiry
        #
        # optionally define `on_success` and `on_failure` callback methods to
        # provide additional controller logic as required
        #
        # options supported include:
        #
        #   :as               defines the name of the form used to access the params
        #                     defaults to the name of the enquiry
        #
        #   :action           overrides the action name.
        #                     by default is is ":index"
        #
        #   :attributes       the list of permitted attributes for initializing the enquiry instance
        #                     defaults to the attributes defined using the `attr_*` helper methods
        #
        def enquiry_controller_for(enquiry_class, options={})
          raise ArgumentError, "#{enquiry_class.name} does not include #{Enquiry.name} module or inherit from #{Enquiry::Base.name}" unless enquiry_class.ancestors.include?(Enquiry)

          options = {
            :as => enquiry_class.name.underscore.gsub(/_enquiry$/, ''),
            :attributes => enquiry_class.query_filter_attributes,
            :action => :index
          }.merge(options)

          action_method = options[:action]

          # define instance methods
          # which provide access to the given
          # enquiry class and the options
          define_method :enquiry_class do
            enquiry_class
          end

          define_method :enquiry_options do
            options
          end

          # define the 'index' action
          class_eval <<-RUBY
            def #{action_method}
              @enquiry = enquiry_class.new()
              if @enquiry.submit(enquiry_params)
                on_success(@enquiry) if self.respond_to?(:on_success)
              else
                on_failure(@enquiry) if self.respond_to?(:on_failure)
              end
            end
          RUBY

          self.include ActionsAndSupport
        end
      end
    end

    module ActionsAndSupport
      extend ActiveSupport::Concern

      included do
        # define the strong parameters method
        def enquiry_params
          params.key?(:reset) ? {} :
            params.fetch(enquiry_options[:as], {})
              .permit(*enquiry_options[:attributes])
              .merge(:page => params.fetch(:page, 1))
        end
      end
    end
  end
end
