require_relative '../../spec_helper'

xdescribe Accela::V4::RegisterCitizen, :vcr do
  describe '::call' do
    it 'returns profile information of the created user' do
      api = Accela::API.connection
      api.login('developer', 'accela', 'records addresses create_citizenaccess_citizens')
      payload = {
        'email' => 'testmdeveloper1@example.com',
        'userName' => 'testmdeveloper1',
        'password' => 'testmdeveloper1',
        'id_provider' => 'citizen',
        'servProvCode' => 'nullisland',
        'serviceProviderCode' => 'nullisland',
        'individualOrOrganization' => 'organization',
        'contacts' => [
          {
            'servProvCode' => 'nullisland',
            'serviceProviderCode' => 'nullisland',
            'id_provider' => 'citizen',
            'organizationName' => 'TEST',
            'businessName' => 'TEST',
            'type' => {
              'value' => 'Organization',
              'text' => 'Organization'
            },
            'status' => {
              'value' => 'A',
              'text' => 'Active'
            }
          }
        ]
      }
      response = described_class.call(payload)
      expect(response).to match(
        'result' => a_hash_including(
          'password' => 'testmdeveloper1',
          'email' => 'testmdeveloper1@example.com',
          'id' => 129_013,
          'userName' => 'testmdeveloper1',
          'servProvCode' => 'nullisland'
        ),
        'status' => 200
      )
    end
  end
end
