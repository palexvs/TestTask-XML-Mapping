$:.unshift File.dirname(__FILE__)

#require 'bundler/setup'
#require 'rubygems'
require 'settings'
require 'grape'
require 'api/api'

run Proxy::API