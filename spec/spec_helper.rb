require 'rubygems'
require 'bundler/setup'

require 'common'

begin
  require 'pry'
rescue LoadError
end

require_relative '../lib/locomotive_models'

RSpec.configure do |config|
  config.filter_run focused: true
  config.run_all_when_everything_filtered = true

  # config.before(:all) do
  #   Locomotive::Models.reset
  #   Locomotive::Models.locale = :en
  # end

  config.before { Locomotive::Models.locale = :en }
  # config.after  {  }
end
