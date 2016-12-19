module Accela
  class DocumentAPI < APIGroup
    as_class_method :get_documents

    def get_documents(*ids)
      Accela::V4::GetDocuments.new(config).result(ids.flatten)
    end
  end
end

