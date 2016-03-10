module Faraday
  class Faraday::SetEncoding < Faraday::Middleware
    def call(environment)
      @app.call(environment).on_complete do |env|
        if env[:response_headers]["content-type"] =~ /json/i
          env[:body] = env[:body].encode(Encoding.find("UTF-8"), invalid: :replace, undef: :replace, replace: '')
        end
      end
    end
  end
end

Faraday::Response.register_middleware set_encoding: Faraday::SetEncoding
