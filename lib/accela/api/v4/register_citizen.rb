module Accela
  module V4
    class RegisterCitizen < Base

      def call(payload)
        post("citizenaccess/citizens", :access_token, {}, payload)
      end

    end
  end
end
