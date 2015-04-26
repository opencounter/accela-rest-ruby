module Accela
  module V4
    class FinalizeRecord < Base

      def call(record_id)
        post("records/#{record_id}/finalize", :access_token, {} )
      end

    end
  end
end
