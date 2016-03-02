require 'mumukit'

Mumukit.configure do |config|
  config.runner_name = 'qsim-server'
  config.command_size_limit = 4096
  config.command_time_limit = 30
end

require_relative './test_hook'
require_relative './metadata_hook'