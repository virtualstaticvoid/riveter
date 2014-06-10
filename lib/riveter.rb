require "riveter/version"

require 'active_model'
require 'active_record'
require 'active_support'
require 'validates_timeliness'

require 'active_support/core_ext'
require 'active_support/inflector'
require 'active_support/inflector'

module Riveter
  autoload :AttributeDefaultValues, 'riveter/attribute_default_values'
  autoload :AssociatedTypeRegistry, 'riveter/associated_type_registry'
  autoload :Attributes, 'riveter/attributes'
  autoload :Command, 'riveter/command'
  autoload :CommandController, 'riveter/command_controller'
  autoload :Enquiry, 'riveter/enquiry'
  autoload :EnquiryController, 'riveter/enquiry_controller'
  autoload :Enumerated, 'riveter/enumerated'
  autoload :HashWithDependency, 'riveter/hash_with_dependency'
  autoload :Presenter, 'riveter/presenter'
  autoload :Query, 'riveter/query'
  autoload :QueryFilter, 'riveter/query_filter'
  autoload :Service, 'riveter/service'
  autoload :Worker, 'riveter/worker'
end

# add autoload's for validators
module ActiveModel
  module Validations
    autoload :BooleanessValidator, 'riveter/booleaness_validator'
    autoload :EmailValidator, 'riveter/email_validator'
  end
end

require 'riveter/errors'
require 'riveter/core_extensions'

# Rails bits...
require 'riveter/rails/railtie' if defined?(::Rails::Railtie)
require 'riveter/rails/engine' if defined?(::Rails)

# include locale in load path
Dir[File.join(File.dirname(__FILE__), '*.yml')].each do |file|
  I18n.load_path << file
end
