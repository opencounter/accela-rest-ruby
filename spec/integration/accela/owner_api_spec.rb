require_relative '../spec_helper'

describe Accela::OwnerAPI, :vcr do
  before(:each) do
    api = Accela::API.connection
    api.login('developer', 'accela', 'owners')
  end

  describe '::get_all_owners' do
    it 'returns a list of Owner objects' do
      owners = Accela::OwnerAPI.get_all_owners state: 'OH'
      expect(owners.length).to eq 16
    end
  end

  describe '::get_owners' do
    it 'returns a single Owner object' do
      owner = Accela::OwnerAPI.get_owners(515_079_627)
      expect(owner.full_name).to eq 'TYSON TERRI L'
      expect(owner.is_primary).to eq 'Y'
    end
  end
end
