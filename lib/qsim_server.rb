require 'mumukit'

Mumukit.configure do |config|
  config.runner_name = 'qsim-server'

end

require_relative './test_hook'
require_relative './metadata_hook'