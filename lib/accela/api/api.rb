module Accela
  class API
    include Escaper

    def self.connection
      new
    end

    def login(username, password, scope, additional = {})
      config.token = auth.login(username, password, scope, additional)
    end

    def get(path, auth_type, query={}, headers={})
      uri = config.base_uri + path
      headers = headers(auth_type).merge(headers)
      escaped_query = escape_query_values(query)
      HTTMultiParty.get(uri, headers: headers , query: escaped_query)
    end

    def put(path, auth_type, query={}, body={}, headers={})
      uri = config.base_uri + path
      headers = headers(auth_type).merge(headers)
      json_body = JSON.generate(body)
      escaped_query = escape_query_values(query)
      HTTMultiParty.put(uri, headers: headers, query: escaped_query, body: json_body)
    end

    def post(path, auth_type, query={}, body={}, headers={})
      uri = config.base_uri + path
      headers = headers(auth_type).merge(headers)
      if body != {}
        json_body = JSON.generate(body)
      else
        json_body = ''
      end
      escaped_query = escape_query_values(query)
      HTTMultiParty.post(uri, headers: headers, query: escaped_query, body: json_body)
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
