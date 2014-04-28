#!/usr/bin/env gem build
# encoding: utf-8

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'locomotive/models/version'

Gem::Specification.new do |s|
  s.name        = 'locomotivecms_models'
  s.version     = Locomotive::Models::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Didier Lafforgue']
  s.email       = ['didier@nocoffee.fr']
  s.homepage    = 'http://www.locomotivecms.com'
  s.summary     = 'LocomotiveCMS Models'
  s.description = 'Persistence framework for LocomotiveCMS. Default adapters: YAML'

  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project         = 'locomotivecms_models'

  # s.add_dependency 'tilt',                            '1.4.1'
  # s.add_dependency 'sprockets',                       '~> 2.0'
  # s.add_dependency 'sprockets-sass'
  # s.add_dependency 'haml',                            '~> 4.0.3'
  # s.add_dependency 'sass',                            '~> 3.2.12'
  # s.add_dependency 'compass',                         '~> 0.12.2'
  # s.add_dependency 'coffee-script',                   '~> 2.2.0'
  # s.add_dependency 'less',                            '~> 2.2.1'
  # s.add_dependency 'RedCloth',                        '~> 4.2.3'

  # s.add_dependency 'tzinfo',                          '~> 0.3.29'
  # s.add_dependency 'chronic',                         '~> 0.10.2'

  s.add_dependency 'activesupport',                   '~> 4.1.0'
  # s.add_dependency 'i18n',                            '~> 0.6.0'
  # s.add_dependency 'stringex',                        '~> 2.0.3'

  # s.add_dependency 'multi_json',                      '~> 1.7.3'
  # s.add_dependency 'httmultiparty',                   '0.3.10'
  # s.add_dependency 'json',                            '~> 1.8.0'
  # s.add_dependency 'mime-types',                      '~> 1.19'

  # s.add_dependency 'zip',                             '~> 2.0.2'
  # s.add_dependency 'colorize',                        '~> 0.5.8'
  # s.add_dependency 'logger'

  s.add_development_dependency 'rake',                '~> 10.3.1'
  s.add_development_dependency 'rspec',               '~> 2.14.1'
  s.add_development_dependency 'mocha',               '~> 1.0.0'

  # s.add_development_dependency 'rack-test',           '~> 0.6.1'
  # s.add_development_dependency 'ruby-debug-wrapper',  '~> 0.0.1'
  # s.add_development_dependency 'vcr',                 '2.4.0'
  # s.add_development_dependency 'therubyracer',        '~> 0.11.4'
  # s.add_development_dependency 'fakeweb'
  # s.add_development_dependency 'webmock',             '1.9.3'
  # s.add_development_dependency 'bson'
  # s.add_development_dependency 'bson_ext'
  # s.add_development_dependency 'typhoeus', '0.5.0'
  # s.add_development_dependency 'faraday' #,             '1.9.3'

  s.require_path = 'lib'

  s.files        = Dir.glob('lib/**/*')
end

