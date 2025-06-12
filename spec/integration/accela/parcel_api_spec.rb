require_relative '../spec_helper'

describe Accela::ParcelAPI, :vcr do
  before(:each) do
    api = Accela::API.connection
    api.login('developer', 'accela', 'parcels')
  end

  describe '::get_all_parcels' do
    it 'returns a list of Parcel objects' do
      parcels = Accela::ParcelAPI.get_all_parcels isPrimary: 'N'
      expect(parcels.length).to eq 25
    end
  end

  describe '::get_parcels' do
    it 'returns a single Parcel object' do
      parcel = Accela::ParcelAPI.get_parcels('00012476')
      expect(parcel.parcel_number).to eq '00012476'
      expect(parcel.parcel_area).to eq 469.81
    end
  end
end
