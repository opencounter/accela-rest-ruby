module Accela
  class CitizenAPI < APIGroup
    as_class_method :register, :get_profile

    def register(payload)
      Accela::V4::RegisterCitizen.new(config).result(payload)
    end

    def get_profile
      Accela::V4::GetCitizenAccessUserProfile.new(config).result
    end
  end
end
