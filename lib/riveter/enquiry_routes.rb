require 'action_dispatch'

module Riveter
  module EnquiryRoutes

    #
    # defines a route for the given enquiry
    #
    # by convention, the word "enquiry" is omitted
    # from the name of the enquiry
    #
    # options include:
    #
    #   :path            overrides the path used.
    #                    by default it is "<enquiry>_enquiry".
    #                    E.g. for :active_portfolios the path is 'active_portfolios'
    #
    #   :controller      overrides the controller used.
    #                    by default it is "<enquiry>_enquiry_controller"
    #
    #   :as              overrides the name of the route generated.
    #                    by default it is "<enquiry>_enquiry"
    #
    #   :action          overrides the action name.
    #                    by default is is ":index"
    #
    # E.g.
    #
    #   enquiry :active_portfolios
    #
    #     creates a route 'active_portfolios' named `active_portfolios_enquiry` to the
    #     `ActivePortfoliosEnquiryController` controller for the 'index' action
    #
    #   enquiry :active_portfolios, :as => 'recent_portfolios'
    #
    #     creates a route 'active_portfolios' named `recent_portfolios` to the
    #     `ActivePortfoliosEnquiryController` controller for the 'index' action
    #
    #   enquiry :active_portfolios, :path => '/all_your_portfolios'
    #
    #     creates a route 'all_your_portfolios' named `active_portfolios_enquiry` to the
    #     `ActivePortfoliosEnquiryController` controller for the 'index' action
    #
    #   enquiry :active_portfolios, :controller => 'my_portfolios_controller'
    #
    #     creates a route 'active_portfolios' named `active_portfolios_enquiry` to the
    #     `MyPortfoliosController` controller for the 'index' action
    #
    def enquiry(enquiry, options={})
      raise ArgumentError, 'Expects a symbol for the enquiry.' unless enquiry.is_a?(Symbol)

      path = options.delete(:path) || enquiry.to_s
      action = options.delete(:action) || :index

      options = {
        :controller => :"#{enquiry}_enquiry",
        :as         => :"#{enquiry}_enquiry"
      }.merge(options)

      # define GET 'index' route
      get path, options.merge(:action => action)

      # define POST 'index' route
      post path, options.merge(:action => action, :as => nil)
    end
  end
end

ActionDispatch::Routing::Mapper.send :include, Riveter::EnquiryRoutes
