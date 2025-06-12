require_relative '../../spec_helper'

describe Accela::V4::GetRecords, :vcr do
  describe '::call' do
    it 'returns a single record when given a single id' do
      api = Accela::API.connection
      api.login('developer', 'accela', 'records addresses')
      id = 'NULLISLAND-25EST-00000-00006'
      payload = Accela::V4::GetRecords.call(id)
      expect(payload['result'].length).to eq 1
    end

    it 'returns multiple records when given a multiple ids' do
      api = Accela::API.connection
      api.login('developer', 'accela', 'records addresses')
      id1 = 'NULLISLAND-REC25-00000-0004Q'
      id2 = 'NULLISLAND-25EST-00000-00006'
      payload = Accela::V4::GetRecords.call(id1, id2)
      expect(payload['result'].length).to eq 2
    end

    it 'expands addresses' do
      api = Accela::API.connection
      api.login('developer', 'accela', 'records addresses')
      id1 = 'NULLISLAND-REC25-00000-0004Q'
      payload = Accela::V4::GetRecords.call(id1, expand: ['addresses'])
      expect(payload['result'].first['addresses'].length).to eq 1
    end
  end
end
