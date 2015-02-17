module Accela
  module V4
    class CreateReport < Base

      def call(id, query, payload)
        headers = {
          'Content-Type' => 'application/json',
          'Accept' => '*/*'
        }
        resp = post("reports/#{id}/", :access_token, query, payload, headers)
        StringIO.new resp
      end

    end
  end
end
