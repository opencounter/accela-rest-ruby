module Accela
  class RenewalInfoTranslator < Translator

    def translation
      [
        [:expiration_date, :expirationDate, :dateTime]
      ]
    end

  end
end

