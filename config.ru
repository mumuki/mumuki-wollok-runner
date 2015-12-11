require 'rubygems'
require 'bundler'

Bundler.require

require 'i18n'
require 'mumukit'

I18n.load_path += Dir[File.join('.', 'locales', '*.yml')]

require_relative 'lib/wollok_server'

run Mumukit::TestServerApp
