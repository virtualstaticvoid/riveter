require 'bundler/setup'
Bundler.setup

require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start do
  add_filter 'spec'
  add_filter 'vendor'
end

require 'pry'

require 'riveter'
require 'riveter/spec_helper'

# NB: sync these requires from the Railtie
require 'riveter/form_builder_extensions'
require 'riveter/command_routes'
require 'riveter/enquiry_routes'

require 'rails/all'
require 'rails/generators'
require 'haml'

require 'shoulda/matchers'
require 'ammeter/init'

require 'fileutils'

# require supporting ruby files with custom matchers and macros, etc
Dir[File.expand_path("../support/**/*.rb", __FILE__)].each {|f| require f }

# configure Rspec
RSpec.configure do |config|

  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  config.mock_with :rspec do |c|
    c.syntax = :expect
  end

  # config.order = :random
  config.fail_fast = (ENV["FAIL_FAST"] == 1)
end

# require examples, must happen after configure for RSpec 3
Dir[File.expand_path("../examples/**/*.rb", __FILE__)].each {|f| require f }

# I18n.enforce_available_locales will default to true in the future.
I18n.enforce_available_locales = true if I18n.respond_to?(:enforce_available_locales)
