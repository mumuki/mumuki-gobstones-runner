require 'mumukit'
require 'erb'

I18n.load_translations_path File.join(__dir__, 'locales', '*.yml')

Mumukit.runner_name = 'gobstones'
Mumukit.configure do |config|
  config.docker_image = 'mumuki/mumuki-gobstones-worker'
  config.content_type = 'html'
  config.structured = true
end

require_relative './builders/error_builder'
require_relative './builders/program_builder'
require_relative './extensions/string'
require_relative './render/html_renderer'
require_relative './test_hook'
require_relative './metadata_hook'
require_relative './checker'
require_relative './multiple_executions_runner'
