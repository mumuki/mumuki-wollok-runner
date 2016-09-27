#\-s puma

require 'i18n'
require 'mumukit'

I18n.load_path += Dir[File.join('.', 'locales', '*.yml')]

require_relative 'lib/wollok_runner'

require 'mumukit/server/app'

run Mumukit::Server::App
