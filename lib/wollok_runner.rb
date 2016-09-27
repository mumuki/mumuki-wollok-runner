require 'mumukit'

Mumukit.runner_name = 'wollok'
Mumukit.configure do |config|
  config.stateful = true
end

require_relative './wollok_hook'
require_relative './test_hook'
require_relative './query_hook'
require_relative './metadata_hook'