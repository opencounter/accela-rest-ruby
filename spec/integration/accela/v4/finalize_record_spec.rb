require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

describe Accela::V4::FinalizeRecord, :vcr do
  describe "::call" do
    it "finalizes a temporary record" do
      # login
      api = Accela::API.connection
      api.login("mdeveloper", "accela", "records settings")

      # create temp record
      payload = Accela::V4::CreatePartialRecord.call({
        "actualProductionUnit" => 123.43,
        "type" => {
          "id"=>"Building-Commercial-Addition-NA"
        }
      })
      expect(payload["result"]["actualProductionUnit"]).to eq 123.43
      expect(payload['result']['id']).to match(/ISLANDTON-\d+EST-.*/)

      # finalize record
      record_id = payload['result']['id']
      payload =  Accela::V4::FinalizeRecord.call(record_id)
      expect(payload['status']).to eq(200)
      expect(payload['result']['id']).to match(/ISLANDTON-\d+CAP-.*/)
    end
  end
end
