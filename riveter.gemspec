# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'riveter/version'

Gem::Specification.new do |spec|
  spec.name          = 'riveter'
  spec.version       = Riveter::VERSION
  spec.authors       = ['Chris Stefano']
  spec.email         = ['virtualstaticvoid@gmail.com']
  spec.summary       = %q{Provides several useful patterns, packaged in a gem, for use in Rails.}
  spec.description   = %q{Provides several useful patterns, such as Enumerated, Command, Enquiry, Query, QueryFilter, Service and Presenter, packaged in a gem, for use in Rails and other Ruby applications.}
  spec.homepage      = 'https://github.com/virtualstaticvoid/riveter'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency 'railties'                     , '>= 4.0.0'
  spec.add_dependency 'activemodel'                  , '>= 4.0.0'
  spec.add_dependency 'validates_timeliness'         , '>= 3.0.0'

  spec.add_development_dependency 'bundler'          , '~> 1.11.2'
  spec.add_development_dependency 'rake'             , '~> 10.4.2'
  spec.add_development_dependency 'rails'            , '~> 4.2.1'
  spec.add_development_dependency 'haml-rails'       , '~> 0.9.0'
  spec.add_development_dependency 'rspec-rails'      , '~> 3.2.1'
  spec.add_development_dependency 'shoulda-matchers' , '~> 2.8.0'
  spec.add_development_dependency 'ammeter'          , '~> 1.1.2'
  spec.add_development_dependency 'coveralls'        , '~> 0.8.1'
  spec.add_development_dependency 'pry'              , '~> 0.10.1'
  spec.add_development_dependency 'pry-byebug'       , '~> 3.1.0'
end
