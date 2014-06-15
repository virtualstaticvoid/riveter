# Riveter

[![Gem Version](https://badge.fury.io/rb/riveter.svg)](http://badge.fury.io/rb/riveter)
[![Build Status](https://secure.travis-ci.org/virtualstaticvoid/riveter.png?branch=master)](http://travis-ci.org/virtualstaticvoid/riveter)
[![Code Climate](https://codeclimate.com/github/virtualstaticvoid/riveter.png)](https://codeclimate.com/github/virtualstaticvoid/riveter)
[![Coverage Status](https://coveralls.io/repos/virtualstaticvoid/riveter/badge.png)](https://coveralls.io/r/virtualstaticvoid/riveter)
[![Dependency Status](https://gemnasium.com/virtualstaticvoid/riveter.svg)](https://gemnasium.com/virtualstaticvoid/riveter)

Provides several useful patterns, packaged in a gem, for use in Rails.
Includes generators to help you improve consistency in your applications.

* Enumerated
* Query
* QueryFilter
* Enquiry
* EnquiryController
* Command
* CommandController
* Service
* Presenter
* Worker

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

E.g.

To generate an enquiry controller, query filter, query, views and associated specs, execute:

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
