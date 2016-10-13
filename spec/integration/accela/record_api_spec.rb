require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Accela::RecordAPI, vcr: { record: :new_episodes } do

  before(:each) do
    api = Accela::API.connection
    api.login("developer", "accela", "records addresses")
  end

  describe "::get_records" do
    it "returns Record objects" do
      record = Accela::RecordAPI.get_records("ISLANDTON-14CAP-00000-000CR").first
      expect(record.initiated_product).to eq "AV360"
      expect(record.public_owned).to eq false
    end
  end

  describe "::get_all_records" do
    it "returns a list of RecordAPI objects" do
      records = Accela::RecordAPI.get_all_records
      expect(records.length).to eq 25
    end
  end

  describe "#create_record" do
    it "persists changes to the model" do
      input_record = Accela::Record.new housing_units: 829,
                                        type: {
                                          id: "Building-Commercial-Addition-NA"
                                        }
      record = Accela::RecordAPI.create_record(input_record)
      expect(record.housing_units).to eq 829
    end

    it "also accepts a hash" do
      record = Accela::RecordAPI.create_record housing_units: 829,
                                               type: {
                                                 id: "Building-Commercial-Addition-NA"
                                               }
      expect(record.housing_units).to eq 829
    end

    it "creates and sets an id" do
      input_record = Accela::Record.new type: {id: "Building-Commercial-Addition-NA" }
      record = Accela::RecordAPI.create_record(input_record)
      expect(record.id).not_to eq nil
    end

  end

  describe "#get_all_addresses_for_record" do
    it "if it has an id fetches a record's set of addresses" do
      record = Accela::RecordAPI.get_records("ISLANDTON-14CAP-00000-000CR").first
      address = Accela::RecordAPI.new(record).get_all_addresses_for_record.first
      expect(address.street_name).to eq "ALLEGHENY"
    end
  end

  describe "#get_all_contacts_for_record" do
    it "fetch a record's contacts" do
      record = Accela::RecordAPI.get_records("ISLANDTON-14CAP-00000-000CR").first
      contact = Accela::RecordAPI.new(record).get_all_contacts_for_record.first
      expect(contact.email).to eq "josh@d-i.co"
    end
  end

  describe "#get_all_parcels_for_record" do
    it "fetch a record's parcels" do
      record = Accela::RecordAPI.get_records("ISLANDTON-14CAP-00000-000CR").first
      parcel = Accela::RecordAPI.new(record).get_all_parcels_for_record.first
      expect(parcel.parcel_number).to eq "137200001"
    end
  end

  describe "#get_all_owners_for_record" do
    it "fetch a record's parcels" do
      record = Accela::RecordAPI.get_records("ISLANDTON-14CAP-00000-000CR").first
      owner = Accela::RecordAPI.new(record).get_all_owners_for_record.first
      expect(owner.full_name).to eq "UTROSKE ROBERT EARL & DIANA LEE"
    end
  end
end

describe Accela::RecordAPI, vcr: { record: :new_episodes } do
  describe "passing in configuration as an object" do
    let(:config) do
      Accela::Configuration.new(app_id: "635395466279594650",
                                app_secret: "3b1e4026d95e4478a0f8dd1f7a1b7028",
                                agency: "islandton",
                                environment: "TEST").tap do |c|
                                  c.token = Accela::Authorize.new(c).login("mdeveloper", "accela", "records")
                                end
    end

    it "works with requests that don't require passing a model" do
      input_record = Accela::Record.new type: {id: "Building-Commercial-Addition-NA" }
      record = Accela::RecordAPI.new(config).create_record(input_record)
      expect(record.id).not_to eq nil
    end

    it "works with requests that require a model object" do
      input_record = Accela::Record.new type: {id: "Building-Commercial-Addition-NA" }, contacts: [{ type: { text: "Applicant", value: "Applicant" } }]
      record = Accela::RecordAPI.new(config).create_record(input_record)
      contacts = Accela::RecordAPI.new(record, config).get_all_contacts_for_record
      expect(contacts.first.id).to_not eq nil
    end
  end
end
