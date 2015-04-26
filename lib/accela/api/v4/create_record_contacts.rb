module Accela
  module V4
    class CreateRecordContacts < Base

      def call(record_id, payload)
        post("records/#{record_id}/contacts", :access_token, {}, payload)
      end

    end
  end
end
