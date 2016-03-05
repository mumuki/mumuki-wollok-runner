require 'mumukit'

Mumukit.configure do |config|
  config.docker_image = 'mumuki/mumuki-wollok-worker'
end

require_relative './test_hook'
require_relative './metadata_hook'