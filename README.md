# Riveter

[![Gem Version](https://badge.fury.io/rb/riveter.svg)](http://badge.fury.io/rb/riveter)
[![Build Status](https://secure.travis-ci.org/virtualstaticvoid/riveter.png?branch=master)](http://travis-ci.org/virtualstaticvoid/riveter)
[![Code Climate](https://codeclimate.com/github/virtualstaticvoid/riveter.png)](https://codeclimate.com/github/virtualstaticvoid/riveter)
[![Coverage Status](https://coveralls.io/repos/virtualstaticvoid/riveter/badge.png)](https://coveralls.io/r/virtualstaticvoid/riveter)
[![Dependency Status](https://gemnasium.com/virtualstaticvoid/riveter.svg)](https://gemnasium.com/virtualstaticvoid/riveter)

Provides several useful patterns, packaged in a gem, for use in Rails and other web based applications, including generators to help improve
consistency in your applications.

## Motivation
In an effort to refactor large Rails applications, a number of patterns emerged, which this gem seeks to formalize. Encapsulating
each pattern helps provide consistency and promotes standardization of implementation in a team of developers. Also, having generators
to create all the necessary classes and specs helps developers follow the standards more easily and prevents unnecessary coding and
ensures the focus remains on the business problem being solved instead.

Some of these patterns have been discussed at length within the Ruby and Rails communities, with many people making cases for
and against some of these patterns. The important thing to bear in mind is that there is no "one" solution for everything, nor
"one" way to solve a problem, so these patterns will _not_ always be applicable. Please use them where it makes sense to do so, and
the solution to the problem you are trying to solve becomes clearer by doing so.

## Patterns Included
The following patterns are included, and an explaination of each follows:

### Enumerated
Rails 4+ now has support for enumerated attributes on models, however the `Riverter::Enumerated` module is a slightly different take on
the idea but can still be used on conjunction with the default functionality.

You define an enumerated type by creating a module, adding the desired members as constants and then include the `Riveter::Enumerated` module.

E.g. Module containing enumeration members:
```ruby
module FooStatusEnum
  Bar = 1
  Baz = 2

  include Riveter::Enumerated
end
```

The `FooStatusEnum` module will now have the following methods exposed:

* `::All` - a constant which behaves like an `Array` for enumerating the members. E.g. `FooBarStatusEnum::All #=> [FooBarStatusEnum::Member1, FooBarStatusEnum::Member2]`
* `human` - if a locale file is provided, gives the human name for the enumeration. E.g. `FooStatusEnum.human #=> "Foo Status"`
* `names` - lists all the member names. E.g. `FooStatusEnum.names #=> [Bar, Baz]`
* `values` - lists all the member values. E.g. `FooStatusEnum.values #=> [1, 2]`
* `collection` - provides a collection of the members for use in form inputs.

And when enumerating over the members using `FooStatusEnum::All`, each member will have the following methods:

* `name` - the member name
* `human` - if a locale file is provided, gives the human name for the member
* `value` - the member value

### QueryFilter
A common requirement in a Rails application is to collect criteria from the user and then prepairing a query using those criteria
within the `where` clauses. The query filter pattern encapsulates the criteria attributes so that they can be converted from params
and validated prior to building up the query.

Create a class which inherits from `Riveter::QueryFilter::Base` and then define the attributes, their default values and validations as needed.

E.g. Query filter example class
```ruby
class FooQueryFilter < Riveter::QueryFilter::Base
  attr_string :bar_like, :required => true
  attr_boolean :baz, :default => true
  attr_date :qux, :default => { Time.now }
end
```

There are a number of `attr_*` methods as follows:

  * `attr_string`
  * `attr_integer`
  * `attr_decimal`
  * `attr_date`
  * `attr_date_range`
  * `attr_time`
  * `attr_boolean`
  * `attr_enum`
  * `attr_array`
  * `attr_hash`
  * `attr_model`
  * `attr_object`

In your controller, create an instance of the query filter as if it were a model. It can be used within your views easily as there is
a view helper method, `query_filter_form_for`, which makes it easy to build HTML forms for the specified attributes.
If you have `simple_form` installed, it will behave like a `simple_form_for`, otherwise the standard Rails `form_for` is used.

E.g. Controller example
```ruby
class FooController < ApplicationController

  def new_search
    @query_filter = FooQueryFilter.new()
  end

  def search
    @query_filter = FooQueryFilter.new(foo_query_filter_params)
    respond_to do |format|
      if @query_filter.valid?
        # E.g. your query logic here
        @list = BarModel.where(:bar => @query_filter.bar_like)
                        .where(:baz => @query_filter.baz)
                        .where(:qux => @query_filter.qux)
        format.html
      else
        format.html {render :action => :new_search}
      end
    end
  end

private
  def foo_query_filter_params
    params.require(:foo_query_filter).permit(:bar_like, :baz, :qux)
  end
end
```

### Query
Given that the query filter is encapsulated, it follows that the query, which is built using the query filter, should be encapsulated too.
Also, considering the controller example code above, it would be better to encapsulate the building of the query into it's own class, instead
of coding it in the controller, especially if the criteria is applied conditionally to the query.

By abstracting the query filter and query as separate classes, it is easier to test each component individually, and there are greater
possibility for reuse of either class in other scenarios.

Create a class which inherits from `Riveter::Query::Base` class and implement the `build_relation` method to define the query.

E.g. The query class
```ruby
class FooQuery < Riveter::Query::Base
  def build_relation(filter)
    query = FooModel.all

    # apply criteria to the query conditionally...
    if filter.bar_like.present?
      query = query.where(:bar => filter.bar_like)
    end

    ...

    query
  end
end
```

The `FooQuery` with now have the following methods, which help in rendering the results in your views:

* `has_data?` - given the relation provided, yields true to indicate whether there is result data
* `relation` - the built relation
* `find_each` - this method is used to enumerate over the result data in the most efficient way

### Enquiry
Since the query filter and query encapsulate filtering and querying, and as they are defined individually, it follows that
there should be a way to bring them together, and thus make them easier to work with in controllers and views.

An enquiry is defined by specifying the query filter and query to use. Provide a class which inherits from `Riveter::Enquiry::Base` and
specify which query filter and query to use with the `filter_with` and `query_with` methods respectively.

E.g. A simple enquiry class
```ruby
class FooEnquiry < Riveter::Enquiry::Base
  filter_with FooQueryFilter
  query_with FooQuery
end
```

In your controller, create an instance of the enquiry as if it were a model. It can be used within your views as there is
a view helper method, `enquiry_form_for`, which makes it easy to build HTML forms for the specified attributes of the query filter.
If you have `simple_form` installed, it will behave like a `simple_form_for`, otherwise the standard Rails `form_for` is used.

Then on submission of the form, call the `submit` method passing in the form parameters, and then enumerate over the resultant data
using the `find_each` method.

E.g. An example enquiry controller
```ruby
class FooEnquiryController < ApplicationController
  def index
    @enquiry = FooEnquiry.new()
    respond_to do |format|
      unless @enquiry.submit(enquiry_params)
        flash[:notice] = 'Invalid enquiry criteria, please correct and try again.'
      end
      format.html
    end
  end

private
  def enquiry_params
    params
      .require(:foo_enquiry)
      .permit(:bar_like, :baz, :qux)
      .merge(:page => params.fetch(:page, 1))
  end
end
```

And the corresponding view, in HAML using `simple_form_for` to build the criteria inputs and Kaminari for pagination:
```haml
.criteria
  = enquiry_form_for(@enquiry) do |f|
    = f.input :bar_like
    = f.input :baz
    = f.input :qux

.results
  %table
    %tr
      %th Foo
      %th Bar
      %th Baz
    - unless @enquiry.has_data?
      %tr
        %td(colspan=3)
          No data found for enquiry...
    - else
      - @enquiry.find_each do |result|
        %tr
          %td= result.bar
          %td= result.bax
          %td= result.qux
  = paginate_enquiry(@enquiry)
```

### EnquiryController
_TDB_

### Command
_TDB_

### CommandController
_TDB_

### Service
_TDB_

### Presenter
_TDB_

## Installation

Add this line to your application's Gemfile:

    gem 'riveter'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install riveter

## Usage

Riverter provides generators for creating boilerplate code necessary for each pattern.

To get the list of available generators, execute:

    $ rails generate

The generator names are prefixed with `riveter`.

E.g. To generate an enquiry controller, query filter, query, views and associated specs, execute:

    $ rails generate riveter:enquiry SomeEnquiryName filter1:string filter2:integer:required

This will create a query with `filter1` string attribute and `filter2` integer attribute, a query, a controller and views:

      invoke  enquiry_controller
      create    app/controllers/my_enquiry_name_enquiry_controller.rb
       route    enquiry :my_enquiry_name
      invoke    haml
      create      app/views/my_enquiry_name_enquiry/index.html.haml
      invoke    rspec
      create      spec/controllers/my_enquiry_name_enquiry_controller_spec.rb
      invoke  query
      create    app/queries/my_enquiry_name_query.rb
      invoke    rspec
      create      spec/queries/my_enquiry_name_query_spec.rb
      invoke  query_filter
      create    app/query_filters/my_enquiry_name_query_filter.rb
      invoke    rspec
      create      spec/query_filters/my_enquiry_name_query_filter_spec.rb
      create  app/enquiries/my_enquiry_name_enquiry.rb
      invoke  rspec
      create    spec/enquiries/my_enquiry_name_enquiry_spec.rb

## Contributing

1. Fork it ( http://github.com/virtualstaticvoid/riveter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License
Released under the MIT License.  See the [LICENSE](LICENSE.txt) file for further details.
