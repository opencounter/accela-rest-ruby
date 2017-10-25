module Accela
  module V4
    class FinalizeRecord < Base

      def call(record_id, payload = :empty_object)
        post("records/#{record_id}/finalize", :access_token, {}, payload)
      end

    end
  end
end
