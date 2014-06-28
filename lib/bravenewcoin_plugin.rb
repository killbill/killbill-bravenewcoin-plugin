require 'active_record'
require 'active_support'
require 'date'
require 'net/http'
require 'pathname'
require 'thread/every'
require 'uri'
require 'yaml'

require 'killbill'

require 'bravenewcoin_plugin/api'
require 'bravenewcoin_plugin/models/ticker'

if defined?(JRUBY_VERSION)
  # See https://github.com/jruby/activerecord-jdbc-adapter/issues/302
  require 'jdbc/mysql'
  Jdbc::MySQL.load_driver(:require) if Jdbc::MySQL.respond_to?(:load_driver)
end
