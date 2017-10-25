module Accela
  module V4
    class FinalizeRecord < Base

      def call(record_id)
        post("records/#{record_id}/finalize", :access_token, {}, :empty_object)
      end

    end
  end
end
