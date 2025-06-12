require_relative '../../spec_helper'

describe Accela::V4::GetAllRecords, :vcr do
  describe '::call' do
    it 'returns a payload with records' do
      payload = Accela::V4::GetAllRecords.call
      expect(payload['result']).to be_truthy
    end
  end
end
