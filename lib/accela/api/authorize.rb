module Accela
  class Authorize
    attr_reader :config

    def initialize(config=Configuration)
      @config = config
    end

    def login(username, password, scope, additional = {})
      complete_body = body.merge({
        "username" => username,
        "password" => password,
        "scope" => scope
      }.merge(additional))

      response = HTTMultiParty.post("https://apis.accela.com/oauth2/token",
                               headers: headers,
                               body: complete_body,
                               logger: nil)
      if response.code == 200
        Token.new(response.parsed_response)
      else
        #binding.pry
        raise AuthorizationError.new(response.parsed_response["error_description"])
      end
    end

    private

    def headers
      {
        "Content-Type" => "application/x-www-form-urlencoded",
        "x-accela-appid" => config.app_id
      }
    end

    def body
      {
        "grant_type" => "password",
        "agency_name" => config.agency,
        "environment" => config.environment,
        "client_id" => config.app_id,
        "client_secret" => config.app_secret
      }
    end

  end
end
