module Accela
  class AccelaError < ::StandardError; end

  class InvalidTokenError < AccelaError; end

  class AuthorizationError < AccelaError; end
  class UnsupportedAuthTypeError < AccelaError; end

  class UnexpectedError < AccelaError; end

  class ConfigurationError < AccelaError
    def initialize(setting, message)
      super "Accela::Configuration.#{setting} #{message}"
    end
  end
end
