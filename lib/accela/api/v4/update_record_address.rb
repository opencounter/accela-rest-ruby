module Accela
  module V4
    class UpdateRecordAddress < Base

      def call(record_id, id, payload)
        put("records/#{record_id}/addresses/#{id}", :access_token, {}, payload)
      end

    end
  end
end
