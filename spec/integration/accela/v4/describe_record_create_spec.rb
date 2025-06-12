require_relative '../../spec_helper'

describe Accela::V4::DescribeRecordCreate, :vcr do
  describe '::call' do
    it 'returns a payload with fields and elements' do
      api = Accela::API.connection
      api.login('developer', 'accela', 'records')
      payload = Accela::V4::DescribeRecordCreate.call
      expect(payload['result']).to be_truthy
    end
  end
end
