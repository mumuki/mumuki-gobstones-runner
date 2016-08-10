require 'mumukit'

Mumukit.runner_name = 'qsim'
Mumukit.configure do |config|
  config.docker_image = 'mumuki/mumuki-qsim-worker'
  config.content_type = 'html'
end

require 'erb'

require_relative './metatest'
require_relative './test_hook'
require_relative './metadata_hook'
require_relative './checker'
require_relative './html_renderer'