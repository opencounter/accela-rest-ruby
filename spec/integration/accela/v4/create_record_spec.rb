require_relative '../../spec_helper'

describe Accela::V4::CreateRecord, :vcr do
  describe '::call' do
    it 'updates attributes on a record' do
      api = Accela::API.connection
      api.login('developer', 'accela', 'create_record')
      payload = Accela::V4::CreateRecord.call({
                                                'actualProductionUnit' => 123.43,
                                                'type' => {
                                                  'id' => 'Building-Residential-Gas-gas'
                                                }
                                              })
      expect(payload['result']['actualProductionUnit']).to eq 123.43
    end
  end
end
