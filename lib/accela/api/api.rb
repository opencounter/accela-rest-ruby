module Accela
  class API
    include Escaper

    def self.connection
      new
    end

    def conn(auth_type, headers)
      Faraday.new(url: config.base_uri) do |c|
        c.headers = headers(auth_type).merge(headers)
        c.adapter :net_http
        c.response :set_encoding
      end
    end

    def login(username, password, scope, additional = {})
      config.token = auth.login(username, password, scope, additional)
    end

    def get(path, auth_type, query={}, headers={})
      conn(auth_type, headers).get(path) do |req|
        req.params = escape_query_values(query)
      end
    end

    def put(path, auth_type, query={}, body={}, headers={})
      conn(auth_type, headers).put(path) do |req|
        req.params = escape_query_values(query)
        req.body = JSON.generate(body)
      end
    end

    def post(path, auth_type, query={}, body={}, headers={})
      if body == {}
        json_body = ''
      else
        json_body = JSON.generate(body)
      end

      conn(auth_type, headers).post(path) do |req|
        req.params = escape_query_values(query)
        req.body = json_body
      end
    end

    private

    def escape_query_values(q)
      q.inject({}) {|r, (key, val)|
        r[key] = escape(val)
        r
      }
    end

    def headers(auth_type)
      base_headers = {
        'Content-Type' =>'application/json',
        'Accept' => 'application/json',
        'x-accela-appid' => config.app_id
      }

      case auth_type.to_sym
      when :access_token
        auth_headers = {
          'Authorization' => config.token.access_token,
          'x-accela-agency' => config.agency
        }
      when :app_credentials
        auth_headers = {
          'x-accela-appsecret' => config.app_secret
        }
      when :no_auth
        auth_headers = {
          'x-accela-environment' => config.environment,
          'x-accela-agency' => config.agency
        }
      else
        raise UnsupportedAuthTypeError.new(auth_type.to_s, "type is not supported")
      end

      base_headers.merge(auth_headers)
    end

    def auth
      Authorize.new(config)
    end

    def config
      Configuration
    end

  end
end
