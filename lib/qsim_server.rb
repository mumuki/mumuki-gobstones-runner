require 'mumukit'

Mumukit.runner_name = 'qsim'
Mumukit.configure do |config|
  config.docker_image = 'faloi/mumuki-qsim-worker'
end

require_relative './test_hook'
require_relative './metadata_hook'