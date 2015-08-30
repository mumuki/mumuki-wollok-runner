require 'mumukit'

require_relative './test_compiler'
require_relative './test_runner'

Mumukit.configure do |config|
  config.command_size_limit = 10000
end
