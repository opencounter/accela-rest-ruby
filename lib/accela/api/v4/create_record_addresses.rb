module Accela
  module V4
    class CreateRecordAddresses < Base

      def call(record_id, payload)
        post("records/#{record_id}/addresses", :access_token, {}, payload)
      end

    end
  end
end
