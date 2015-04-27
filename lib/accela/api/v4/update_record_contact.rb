module Accela
  module V4
    class UpdateRecordContact < Base

      def call(record_id, id, payload)
        put("records/#{record_id}/contacts/#{id}", :access_token, {}, payload)
      end

    end
  end
end
