require "riveter/version"

require 'active_model'
require 'active_support'
require 'validates_timeliness'

require 'active_support/core_ext'
require 'active_support/inflector'

module Riveter
  autoload :AttributeDefaultValues, 'riveter/attribute_default_values'
  autoload :AssociatedTypeRegistry, 'riveter/associated_type_registry'
  autoload :Attributes, 'riveter/attributes'
  autoload :BooleanessValidator, 'riveter/booleaness_validator'
  autoload :Command, 'riveter/command'
  autoload :CommandController, 'riveter/command_controller'
  autoload :DateRangeValidator, 'riveter/date_range_validator'
  autoload :EmailValidator, 'riveter/email_validator'
  autoload :Enquiry, 'riveter/enquiry'
  autoload :EnquiryController, 'riveter/enquiry_controller'
  autoload :Enumerated, 'riveter/enumerated'
  autoload :HashWithDependency, 'riveter/hash_with_dependency'
  autoload :Presenter, 'riveter/presenter'
  autoload :Query, 'riveter/query'
  autoload :QueryFilter, 'riveter/query_filter'
  autoload :Service, 'riveter/service'
end

# add autoload's for validators
module ActiveModel
  module Validations
    autoload :BooleanessValidator, 'riveter/booleaness_validator'
    autoload :DateRangeValidator, 'riveter/date_range_validator'
    autoload :EmailValidator, 'riveter/email_validator'
  end
end

require 'riveter/errors'
require 'riveter/core_extensions'

# Rails bits...
require 'riveter/rails/railtie' if defined?(::Rails::Railtie)
require 'riveter/rails/engine' if defined?(::Rails)

# include locale in load path
I18n.load_path += Dir.glob(File.expand_path('../../config/locales/*.yml', __FILE__))
