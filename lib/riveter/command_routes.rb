require 'action_dispatch'

module Riveter
  module CommandRoutes

    #
    # defines a route for the given command
    #
    # by convention, the word "command" is omitted
    # from the name of the command
    #
    # options include:
    #
    #   :path            overrides the path used.
    #                    by default it is "<command>_command".
    #                    E.g. for :create_portfolio the path is 'create_portfolio'
    #
    #   :controller      overrides the controller used.
    #                    by default it is "<command>_command_controller"
    #
    #   :as              overrides the name of the route generated.
    #                    by default it is "<command>_command"
    #
    #   :new_action      overrides the new action name
    #                    by default it is "new"
    #
    #   :create_action   overrides the create action name
    #                    by default it is "create"
    #
    # E.g.
    #
    #   command :create_portfolio
    #
    #     creates a route 'create_portfolio' named `create_portfolio_command` to the
    #     `CreatePortfolioCommandController` controller for the 'new' and 'create' actions
    #
    #   command :create_portfolio, :as => 'new_portfolio'
    #
    #     creates a route 'create_portfolio' named `new_portfolio` to the
    #     `CreatePortfolioCommandController` controller for the 'new' and 'create' actions
    #
    #   command :create_portfolio, :path => '/define_portfolio'
    #
    #     creates a route 'define_portfolio' named `create_portfolio_command` to the
    #     `CreatePortfolioCommandController` controller for the 'new' and 'create' actions
    #
    #   command :create_portfolio, :controller => 'my_portfolio_controller'
    #
    #     creates a route 'create_portfolio' named `create_portfolio_command` to the
    #     `MyPortfolioController` controller for the 'new' and 'create' actions
    #
    def command(command, options={})
      raise ArgumentError, 'Expects a symbol for the command.' unless command.is_a?(Symbol)

      path = options.delete(:path) || command.to_s
      new_action = options.delete(:new_action) || :new
      create_action = options.delete(:create_action) || :create

      options = {
        :controller => :"#{command}_command",
        :as => :"#{command}_command"
      }.merge(options)

      # define GET 'new' route
      get path, options.merge(:action => new_action)

      # define POST 'create' route
      post path, options.merge(:action => create_action, :as => nil)
    end
  end
end

ActionDispatch::Routing::Mapper.send :include, Riveter::CommandRoutes
