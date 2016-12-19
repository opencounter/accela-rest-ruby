module Accela
  module V4
    class GetDocuments < Base
      def call(document_ids)
        get("documents/#{document_ids.join(",")}", :access_token)
      end
    end
  end
end
