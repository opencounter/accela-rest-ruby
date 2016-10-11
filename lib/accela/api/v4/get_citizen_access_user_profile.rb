module Accela
  module V4
    class GetCitizenAccessUserProfile < Base
      def call
        get("citizenaccess/profile", :access_token)
      end
    end
  end
end
