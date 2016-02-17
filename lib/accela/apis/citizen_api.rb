module Accela
  class CitizenAPI < APIGroup
    as_class_method :register

    def register(payload)
      Accela::V4::RegisterCitizen.result(payload)
    end
  end
end
