module Accela
  module V4
    class InitializePayment < Base

      def call(payload)
        post("payments/initialize", :access_token, {}, payload)
      end

    end
  end
end
