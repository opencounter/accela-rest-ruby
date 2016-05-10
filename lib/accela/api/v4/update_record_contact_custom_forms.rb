module Accela
  module V4
    class UpdateRecordContactCustomForms < Base
      def call(record_id, contact_id, payload)
        post("records/#{record_id}/contacts/#{contact_id}/customForms", :access_token, {}, payload)
      end
    end
  end
end
