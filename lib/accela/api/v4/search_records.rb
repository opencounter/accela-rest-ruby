module Accela
  module V4
    class SearchRecords < Base

      def call(params = {}, payload)
        post("search/records", :access_token, params, payload)
      end

    end
  end
end
