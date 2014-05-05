require_relative 'lib/locomotive/models/version'

Gem::Specification.new do |spec|
  spec.name        = 'locomotivecms_models'
  spec.version     = Locomotive::Models::VERSION
  spec.platform    = Gem::Platform::RUBY
  spec.authors     = ['Didier Lafforgue', 'Arnaud Sellenet', 'Joel Azemar']
  spec.email       = ['did@locomotivecms.com', 'arnaud@sellenet.fr', 'joel.azemar@gmail.com']
  spec.homepage    = 'http://www.locomotivecms.com'
  spec.summary     = 'LocomotiveCMS Models'
  spec.description = 'Persistence framework for LocomotiveCMS. Default adapters: YAML'

  spec.required_rubygems_version = '>= 1.3.6'
  spec.rubyforge_project         = 'locomotivecms_models'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.executables   = ['models']

  # spec.add_dependency 'tilt',                            '1.4.1'
  # spec.add_dependency 'sprockets',                       '~> 2.0'
  # spec.add_dependency 'sprockets-sass'
  # spec.add_dependency 'haml',                            '~> 4.0.3'
  # spec.add_dependency 'sass',                            '~> 3.2.12'
  # spec.add_dependency 'compass',                         '~> 0.12.2'
  # spec.add_dependency 'coffee-script',                   '~> 2.2.0'
  # spec.add_dependency 'less',                            '~> 2.2.1'
  # spec.add_dependency 'RedCloth',                        '~> 4.2.3'

  # spec.add_dependency 'tzinfo',                          '~> 0.3.29'
  # spec.add_dependency 'chronic',                         '~> 0.10.2'

  spec.add_dependency 'activesupport',                   '~> 4.1.0'
  spec.add_dependency 'i18n',                            '~> 0.6.9'
  # spec.add_dependency 'stringex',                        '~> 2.0.3'

  # spec.add_dependency 'multi_json',                      '~> 1.7.3'
  # spec.add_dependency 'httmultiparty',                   '0.3.10'
  # spec.add_dependency 'json',                            '~> 1.8.0'
  # spec.add_dependency 'mime-types',                      '~> 1.19'

  # spec.add_dependency 'zip',                             '~> 2.0.2'
  # spec.add_dependency 'colorize',                        '~> 0.5.8'
  # spec.add_dependency 'logger'
  spec.add_dependency 'locomotivecms_common',              '~> 0.0.1'

  spec.add_development_dependency 'rake',                '~> 10.3.1'
  spec.add_development_dependency 'rspec',               '~> 2.14.1'
  # spec.add_development_dependency 'mocha',               '~> 1.0.0'

  # spec.add_development_dependency 'rack-test',           '~> 0.6.1'
  # spec.add_development_dependency 'ruby-debug-wrapper',  '~> 0.0.1'
  # spec.add_development_dependency 'vcr',                 '2.4.0'
  # spec.add_development_dependency 'therubyracer',        '~> 0.11.4'
  # spec.add_development_dependency 'fakeweb'
  # spec.add_development_dependency 'webmock',             '1.9.3'
  # spec.add_development_dependency 'bson'
  # spec.add_development_dependency 'bson_ext'
  # spec.add_development_dependency 'typhoeus', '0.5.0'
  # spec.add_development_dependency 'faraday' #,             '1.9.3'
end
