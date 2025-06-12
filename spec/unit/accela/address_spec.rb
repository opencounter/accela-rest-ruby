require_relative '../../spec_helper'

describe Accela::Address, :vcr do
  describe '::has_one' do
    let(:input) do
      {
        is_primary: 'Y',
        country: {
          value: 'US',
          text: 'United States'
        },
        street_suffix: {
          value: 'LN',
          text: 'LN'
        }
      }
    end

    let(:address) { Accela::Address.new(input) }

    it 'exposes sub-objects' do
      expect(address.country.text).to eq 'United States'
      expect(address.street_suffix.text).to eq 'LN'
    end
  end
end
