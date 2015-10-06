module Accela
  module V4
    class GetRecordCustomTables < Base

      def call(id)
        get("records/#{id}/customTables", :access_token)
      end

    end
  end
end
