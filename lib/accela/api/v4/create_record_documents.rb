module Accela
  module V4
    class CreateRecordDocuments < Base

      def call(record_id, payload)
        post("records/#{record_id}/documents", :access_token, {}, payload)
      end

    end
  end
end
