require 'mumukit'

Mumukit.runner_name = 'wollok'
Mumukit.configure do |config|
end

require_relative './interpolator'
require_relative './flags'
require_relative './wollok_hook'
require_relative './test_hook'
require_relative './query_hook'
require_relative './metadata_hook'