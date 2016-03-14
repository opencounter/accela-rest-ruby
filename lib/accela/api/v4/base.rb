module Accela
  module V4
    class Base

      def self.result(*args)
        payload = call(*args)
        payload["result"]
      end

      def self.call(*args)
        new.call(*args)
      end

      def get(uri, auth_type, query={}, headers={})
        handle(API.connection.get(expand_uri(uri),
                                  auth_type,
                                  query,
                                  headers))
      end

      def post(uri, auth_type, query={}, payload={}, headers={})
        handle(API.connection.post(expand_uri(uri),
                                   auth_type,
                                   query,
                                   payload,
                                   headers))
      end

      def put(uri, auth_type, query={}, payload={}, headers={})
        handle(API.connection.put(expand_uri(uri),
                                  auth_type,
                                  query,
                                  payload,
                                  headers))
      end

      private

      def expand_uri(uri)
        "/v4/#{uri}"
      end

      def handle(response)
        if !is_success?(response)
          ErrorHandler.handle(response)
        elsif response.headers["content-type"] =~ /json/
          JSON.load response.body
        else
          response.body
        end
      end

      def is_success?(response)
        response.success?
      end
    end
  end
end
