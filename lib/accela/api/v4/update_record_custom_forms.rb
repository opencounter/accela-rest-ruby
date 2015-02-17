module Accela
  module V4
    class UpdateRecordCustomForms < Base

      def call(id, payload)
        put("records/#{id}/customForms", :access_token, {}, payload)
      end

    end
  end
end
