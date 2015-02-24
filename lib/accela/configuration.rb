module Accela
  class Configuration
    BASE_URI = 'https://apis.accela.com'
    API_VERSION = "4"

    class << self
      attr_writer :app_id, :app_secret, :agency, :environment, :token
    end

    attr_reader :app_id, :app_secret, :agency, :environment, :token

    def self.attr_reader_safe(*attrs)
      eclass = (class << self; self; end)
      attrs.each do |attribute|
        eclass.send(:define_method, attribute) do
          attribute_value = instance_variable_get("@#{attribute}")
          raise ConfigurationError.new(attribute.to_s, "needs to be set") unless attribute_value
          attribute_value
        end
      end
    end

    attr_reader_safe :app_id, :app_secret, :agency, :environment

    TokenFromEnv = Struct.new(:access_token)
    def self.token
      if access_token = ENV['ACCELA_ACCESS_TOKEN']
        TokenFromEnv.new(access_token)
      else
        raise InvalidTokenError.new("You do not have a token.") unless @token
        @token
      end
    end

    def self.base_uri
      BASE_URI
    end

    def initialize(conf={})
      %i[app_id app_secret agency environment].each do |attr|
        instance_variable_set :"@#{attr}", conf[attr]
      end
    end

  end
end
