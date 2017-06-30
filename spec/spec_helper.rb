unless defined?(SPEC_HELPER_LOADED)
  SPEC_HELPER_LOADED = true

  require "rubygems"
  require "bundler/setup"
  require "pry"

  require_relative "../lib/accela"

  Accela::Configuration.app_id = "635395466279594650"
  Accela::Configuration.app_secret = "3b1e4026d95e4478a0f8dd1f7a1b7028"
  Accela::Configuration.agency = "islandton"
  Accela::Configuration.environment = "TEST"

  Accela::API::LOGGER.level = Logger::FATAL
end
