require_relative '../spec_helper'

describe Accela::Address, :vcr do
  before(:each) do
    api = Accela::API.connection
    api.login('developer', 'accela', 'addresses')
  end

  describe '::get_all_addresses' do
    it 'returns a list of Address objects' do
      addresses = Accela::AddressAPI.get_all_addresses(country: 'US')
      expect(addresses.length).to eq 25
    end
  end

  describe '::get_addresses' do
    it 'returns a single Address object' do
      address = Accela::AddressAPI.get_addresses(2)
      expect(address.street_name).to eq 'HUNTINGTON'
      expect(address.city).to eq 'SUNRISE'
    end
  end
end
