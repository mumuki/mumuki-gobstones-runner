require 'i18n'
require 'mumukit'
require 'erb'

I18n.load_path += Dir[File.join('.', 'locales', '*.yml')]

Mumukit.runner_name = 'qsim'
Mumukit.configure do |config|
  config.docker_image = 'mumuki/mumuki-qsim-worker'
  config.content_type = 'html'
  config.structured = true
end

require_relative './metatest'
require_relative './test_hook'
require_relative './metadata_hook'
require_relative './checker'
require_relative './html_renderer'