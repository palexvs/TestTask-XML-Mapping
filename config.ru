$:.unshift File.dirname(__FILE__)

require 'grape'
require 'active_support/json'
require './settings'
require './model/user_xml'
require './db/cache'
require './api/api'

run Proxy::API