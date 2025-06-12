require 'rubygems'
require 'bundler/setup'
require 'rspec'
require 'pry'
require 'webmock'

require_relative '../lib/accela'

SPEC_HELPER_LOADED = true
Accela::Configuration.app_id = '638853549908464776'
Accela::Configuration.app_secret = '4588a663f51143e69432e2734143e44b'
Accela::Configuration.agency = 'nullisland'
Accela::Configuration.environment = 'TEST'

Accela::API::LOGGER.level = Logger::FATAL

WebMock.enable!
