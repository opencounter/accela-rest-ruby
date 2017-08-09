module Accela
  class Authorize
    attr_reader :config

    def initialize(config=Configuration)
      @config = config
    end

    def login(username, password, scope, additional = {})
      headers = { "x-accela-appid" => config.app_id }
      body = {
        "grant_type" => "password",
        "agency_name" => config.agency,
        "environment" => config.environment,
        "client_id" => config.app_id,
        "client_secret" => config.app_secret,
        "username" => username,
        "password" => password,
        "scope" => scope
      }.merge(additional)

      response = conn.post("/oauth2/token") do |req|
        req.headers = headers
        req.body = body
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
      response = conn.post("/oauth2/token") do |req|
        req.body = body
      end

      if response.success?
        Token.new JSON.load(response.body)
      else
        #binding.pry
        raise AuthorizationError.new(JSON.load(response.body)["error_description"])
      end
    end

    def exchange_accela_code_for_token(code, redirect_uri)
      headers = { "x-accela-appid" => config.app_id }
      body = {
        "grant_type" => "authorization_code",
        "client_id" => config.app_id,
        "client_secret" => config.app_secret,
        "redirect_uri" => redirect_uri,
        "code" => code,
      }

      response = conn.post("/oauth2/token") do |req|
        req.headers = headers
        req.body = body
      end

      if response.success?
        Token.new JSON.load(response.body)
      else
        raise AuthorizationError.new(JSON.load(response.body)["error_description"])
      end
    end

    def validate(token)
      headers = { "Authorization" => token }
      response = conn.get("/oauth2/tokeninfo") do |req|
        req.headers = headers
      end

      if response.success?
        JSON.load(response.body)
      else
        raise AuthorizationError.new(JSON.load(response.body)["error_description"])
      end
    end

    private

    def conn
      Faraday.new("https://apis.accela.com") do |c|
        c.request :url_encoded
        c.response :detailed_logger, Accela::API::LOGGER
        c.adapter :net_http
      end
    end
  end
end
