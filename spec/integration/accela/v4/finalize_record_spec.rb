require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

describe Accela::V4::FinalizeRecord, :vcr do
  describe "::call" do
    it "finalizes a temporary record" do
      # login
      api = Accela::API.connection
      api.login("mdeveloper", "accela", "records settings")

      # create temp record
      response = Accela::V4::CreatePartialRecord.call({
        "actualProductionUnit" => 123.43,
        name: "Commercial Building Permit",
        "type" => {
          "id"=>"Building-Commercial-Addition-NA"
        }
      })
      expect(response["result"]["actualProductionUnit"]).to eq 123.43
      expect(response['result']['id']).to match(/ISLANDTON-\d+EST-.*/)
      expect(response['result']['name']).to eq("Commercial Building Permit")

      # finalize record
      record_id = response['result']['id']
      response =  Accela::V4::FinalizeRecord.call(record_id, { name: "Commercial Building Permit" })
      expect(response['status']).to eq(200)
      expect(response['result']['id']).to match(/ISLANDTON-\d+CAP-.*/)
      expect(response['result']['name']).to eq("Commercial Building Permit")
    end
  end
end
