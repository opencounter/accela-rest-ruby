module Accela
  module V4
    class UpdateRecordContactCustomTables < Base
      def call(record_id, contact_id, payload)
        put("records/#{record_id}/contacts/#{contact_id}/customTables", :access_token, {}, payload)
      end
    end
  end
end
