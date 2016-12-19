module Accela
  module V4
    class CreateRecordDocuments < Base
      def call(record_id, payload)
        headers = { 'Content-Type' =>'multipart/form-data', }
        post("records/#{record_id}/documents", :access_token, {}, payload, headers)
      end
    end
  end
end
