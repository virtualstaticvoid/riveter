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
  spec.description   = %q{Provides several useful patterns, such as Enumerated, Command, Enquiry, Query, QueryFilter, Service, Presenter and Worker, packaged in a gem, for use in Rails and other Ruby applications.}
  spec.homepage      = 'https://github.com/virtualstaticvoid/riveter'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency 'railties', '~> 4.0.0'
  spec.add_dependency 'actionpack'
  spec.add_dependency 'activemodel'
  spec.add_dependency 'activerecord'
  spec.add_dependency 'activesupport'
  spec.add_dependency 'validates_timeliness'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rails', '~> 4.0.5'
  spec.add_development_dependency 'haml-rails'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'shoulda-matchers', '~> 2.6.1'
  spec.add_development_dependency 'ammeter'
  spec.add_development_dependency 'simplecov', '~> 0.7.1'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
end
