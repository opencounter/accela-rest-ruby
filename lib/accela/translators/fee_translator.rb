module Accela
  class FeeTranslator < Translator

    def translation
      [
        [:code, :code, :string],
        [:id, :id, :string],
        [:is_success, :isSuccess, :boolean],
        [:message, :message, :string],
        [:quantity, :quantity, :double],
        [:record_id, :recordId, :string]
      ]
    end
  end
end
