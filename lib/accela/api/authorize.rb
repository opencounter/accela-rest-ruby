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
      connection = Faraday.new("https://apis.accela.com")
      response = connection.post("/oauth2/token") do |req|
        req.headers = headers
        req.body = complete_body
      end

      if response.success?
        Token.new JSON.load(response.body)
      else
        raise AuthorizationError.new(JSON.load(response.body)["error_description"])
      end
    end

    def refresh(refresh_token)
      body = {
        "client_id" => config.app_id,
        "client_secret" => config.app_secret,
        "environment" => config.environment,
        "grant_type" => "refresh_token",
        "refresh_token" => refresh_token
      }
      response = Faraday.new("https://apis.accela.com").post("/oauth2/token") do |req|
        req.headers = { "Content-Type" => "application/x-www-form-urlencoded" }
        req.body = body
      end

      if response.success?
        Token.new JSON.load(response.body)
      else
        #binding.pry
        raise AuthorizationError.new(JSON.load(response.body)["error_description"])
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
