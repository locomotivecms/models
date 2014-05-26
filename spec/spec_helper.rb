require 'rubygems'
require 'bundler/setup'

require 'common'

begin
  require 'pry'
rescue LoadError
end

require_relative '../lib/locomotive_models'

load File.dirname(__FILE__) + '/support/data.rb'

RSpec.configure do |config|
  config.filter_run focused: true
  config.run_all_when_everything_filtered = true
  # config.before { }
  # config.after  { }
end
