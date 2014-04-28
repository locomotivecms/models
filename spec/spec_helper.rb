require 'rubygems'
require 'bundler/setup'

require 'common'

begin
  require 'pry'
rescue LoadError
end

require_relative '../lib/locomotive_models'

RSpec.configure do |config|
  config.mock_with :mocha

  config.filter_run focused: true
  config.run_all_when_everything_filtered = true
end
