require 'bundler/setup'
Bundler.setup

require 'riveter'

# NB: sync these requires from the Railtie
require 'riveter/form_builder_extensions'
require 'riveter/command_routes'
require 'riveter/enquiry_routes'

require 'rails/all'
require 'rails/generators'
require 'haml'

require 'rspec/autorun'
require 'shoulda/matchers'
require 'ammeter/init'
require 'fileutils'
require 'simplecov'
require 'pry'

SimpleCov.start do
  add_filter 'spec'
end

class TestApp < Rails::Application
  config.root = File.dirname(__FILE__)
end
Rails.application = TestApp

module Rails
  def self.root
    @root ||= File.expand_path(File.join(File.dirname(__FILE__), '..', 'tmp', 'rails'))
  end
end
Rails.application.config.root = Rails.root

# Call configure to load the settings from
# Rails.application.config.generators to Rails::Generators
Rails::Generators.configure! Rails.application.config.generators

# require supporting ruby files with custom matchers and macros, etc
Dir[File.expand_path("../support/**/*.rb", __FILE__)].each {|f| require f }

# configure Rspec
RSpec.configure do |config|
  # config.order = :random
  config.fail_fast = (ENV["FAIL_FAST"] == 1)
end

# require examples, must happen after configure for RSpec 3
Dir[File.expand_path("../examples/**/*.rb", __FILE__)].each {|f| require f }

# I18n.enforce_available_locales will default to true in the future.
I18n.enforce_available_locales = true if I18n.respond_to?(:enforce_available_locales)
