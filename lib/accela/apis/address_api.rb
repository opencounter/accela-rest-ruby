module Accela
  class AddressAPI < APIGroup
    as_class_method :get_addresses, :get_all_addresses, :search_addresses

    def get_addresses(*args)
      fetch_one(Accela::V4::GetAddresses,
                AddressTranslator,
                Address,
                *args)
    end

    def get_all_addresses(*args)
      fetch_many(Accela::V4::GetAllAddresses,
                 AddressTranslator,
                 Address,
                 *args)
    end

    def search_addresses(input)
      raw = input.is_a?(Hash) ? input : input.raw
      payload = AddressTranslator.ruby_to_json([raw])
      addresses  = Accela::V4::SearchAddresses.new(config).result(payload.first) || []
      returned_addresses = [] #AddressTranslator.json_to_ruby([addresses]).first
      addresses.each do |i|
        #returned_addresses.push(AddressTranslator.json_to_ruby([i]))
        translated_address = AddressTranslator.json_to_ruby([i])
        returned_addresses.push(Hash[*translated_address.flatten])
      end
      returned_addresses
    end

  end
end
