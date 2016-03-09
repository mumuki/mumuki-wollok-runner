require 'mumukit'

Mumukit.configure do |config|
  config.docker_image = 'mumuki/mumuki-wollok-worker'
  config.command_time_limit = 10
end

require_relative './test_hook'
require_relative './query_hook'
require_relative './metadata_hook'