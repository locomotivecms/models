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
  # spec.executables   = ['models']

  spec.add_dependency 'activesupport',        '~> 4.1.0'
  spec.add_dependency 'i18n',                 '~> 0.6.9'
  spec.add_dependency 'locomotivecms_common', '~> 0.0.1'

  spec.add_development_dependency 'rake',     '~> 10.3.1'
  spec.add_development_dependency 'rspec',    '~> 2.14.1'
end
