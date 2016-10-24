require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

describe Accela::V4::RegisterCitizen, :vcr do
  describe "::call" do
    it "returns profile information of the created user" do
      api = Accela::API.connection
      api.login("mdeveloper", "accela", "records addresses")
      payload = {
        "email" => "testmdeveloper1@example.com",
        "userName" => "testmdeveloper1",
        "password" => "testmdeveloper1",
        "id_provider" => "citizen",
        "servProvCode" => "islandton",
        "serviceProviderCode" => "islandton",
        "individualOrOrganization" => "organization",
        "contacts" => [
          {
            "servProvCode" => "islandton",
            "serviceProviderCode" => "islandton",
            "id_provider" => "citizen",
            "organizationName" => "TEST",
            "businessName" => "TEST",
            "type" => {
              "value" => "Organization",
              "text" => "Organization"
            },
            "status" => {
              "value" => "A",
              "text" => "Active"
            }
          }
        ]
      }
      response = described_class.call(payload)
      expect(response).to match(
       "result" => a_hash_including(
         "password"=>"testmdeveloper1",
         "email"=>"testmdeveloper1@example.com",
         "id"=>129013,
         "userName"=>"testmdeveloper1",
         "servProvCode"=>"ISLANDTON",
       ),
       "status" => 200
      )
    end
  end
end
