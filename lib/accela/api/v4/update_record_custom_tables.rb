module Accela
  module V4
    class UpdateRecordCustomTables < Base

      def call(id, payload)
        put("records/#{id}/customTables", :access_token, {}, payload)
      end

    end
  end
end
