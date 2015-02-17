module Accela
  module V4
    class CreateRecordFees < Base

      def call(record_id, payload)
        post("records/#{record_id}/fees", :access_token, {}, payload)
      end

    end
  end
end
