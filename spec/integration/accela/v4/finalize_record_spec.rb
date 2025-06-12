require_relative '../../spec_helper'

xdescribe Accela::V4::FinalizeRecord, :vcr do
  describe '::call' do
    it 'finalizes a temporary record' do
      # login
      api = Accela::API.connection
      api.login('developer', 'accela', 'records settings')

      # create temp record
      response = Accela::V4::CreatePartialRecord.call({
                                                        'actualProductionUnit' => 123.43,
                                                        name: 'Commercial Building Permit',
                                                        'type' => {
                                                          'id' => 'Building-Commercial-Addition-NA'
                                                        }
                                                      })
      expect(response['result']['actualProductionUnit']).to eq 123.43
      expect(response['result']['id']).to match(/NULLISLAND-\d+EST-.*/)
      expect(response['result']['name']).to eq('Commercial Building Permit')

      # finalize record
      record_id = response['result']['id']
      response =  Accela::V4::FinalizeRecord.call(record_id, { name: 'Commercial Building Permit' })
      expect(response['status']).to eq(200)
      expect(response['result']['id']).to match(/NULLISLAND-\D+CAP-.*/)
      expect(response['result']['name']).to eq('Commercial Building Permit')
    end
  end
end
