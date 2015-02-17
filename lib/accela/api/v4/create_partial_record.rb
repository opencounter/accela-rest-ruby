module Accela
  module V4
    class CreatePartialRecord < Base

      def call(payload)
        post("records/initialize", :access_token, {}, payload)
      end

    end
  end
end
