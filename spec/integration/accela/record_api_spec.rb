require_relative '../spec_helper'

describe Accela::RecordAPI, vcr: { record: :new_episodes } do
  before(:each) do
    api = Accela::API.connection
    api.login('developer', 'accela', 'records addresses')
  end

  describe '::get_records' do
    it 'returns Record objects' do
      record = Accela::RecordAPI.get_records('NULLISLAND-REC25-00000-0004Q').first
      expect(record.initiated_product).to eq 'AV360'
      expect(record.public_owned).to eq false
    end
  end

  describe '::get_all_records' do
    it 'returns a list of RecordAPI objects' do
      records = Accela::RecordAPI.get_all_records
      expect(records.length).to eq 25
    end
  end

  describe '#create_record' do
    it 'persists changes to the model' do
      input_record = Accela::Record.new housing_units: 829,
                                        type: {
                                          id: 'Building-Commercial-Addition-NA'
                                        }
      record = Accela::RecordAPI.create_record(input_record)
      expect(record.housing_units).to eq 829
    end

    it 'also accepts a hash' do
      record = Accela::RecordAPI.create_record housing_units: 829,
                                               type: {
                                                 id: 'Building-Commercial-Addition-NA'
                                               }
      expect(record.housing_units).to eq 829
    end

    it 'creates and sets an id' do
      input_record = Accela::Record.new type: { id: 'Building-Commercial-Addition-NA' }
      record = Accela::RecordAPI.create_record(input_record)
      expect(record.id).not_to eq nil
    end
  end

  let(:magic_record_sure_hope_no_one_deletes_this_smh) { 'NULLISLAND-REC25-00000-0004L' }
  let(:magic_record2_sure_hope_no_one_deletes_this_smh) { 'NULLISLAND-REC25-00000-0004O' }
  describe '#get_all_addresses_for_record' do
    it "if it has an id fetches a record's set of addresses" do
      record = Accela::RecordAPI.get_records(magic_record_sure_hope_no_one_deletes_this_smh).first
      # binding.pry
      address = Accela::RecordAPI.new(record).get_all_addresses_for_record.first
      # binding.pry
      expect(address.street_name).to eq 'Bannatyne'
    end
  end

  describe '#get_all_contacts_for_record' do
    it "fetch a record's contacts" do
      record = Accela::RecordAPI.get_records(magic_record_sure_hope_no_one_deletes_this_smh).first
      contact = Accela::RecordAPI.new(record).get_all_contacts_for_record.first
      expect(contact.email).to eq 'qetesting@mailinator.com'
    end
  end

  describe '#get_all_parcels_for_record' do
    it "fetch a record's parcels" do
      record = Accela::RecordAPI.get_records(magic_record2_sure_hope_no_one_deletes_this_smh).first
      parcels = Accela::RecordAPI.new(record).get_all_parcels_for_record
      expect(parcels.first&.parcel_number).to eq '10'
    end
  end

  describe '#get_all_owners_for_record' do
    it "fetch a record's owners" do
      record = Accela::RecordAPI.get_records(magic_record2_sure_hope_no_one_deletes_this_smh).first
      owners = Accela::RecordAPI.new(record).get_all_owners_for_record
      expect(owners.map(&:full_name)).to contain_exactly('Hindreen', 'Lis')
    end
  end
end

describe Accela::RecordAPI, vcr: { record: :new_episodes } do
  describe 'passing in configuration as an object' do
    let(:config) do
      Accela::Configuration.new(app_id: '638853549908464776',
                                app_secret: '4588a663f51143e69432e2734143e44b',
                                agency: 'nullisland',
                                environment: 'TEST').tap do |c|
                                  c.token = Accela::Authorize.new(c).login('developer', 'accela', 'records')
                                end
    end

    it "works with requests that don't require passing a model" do
      input_record = Accela::Record.new type: { id: 'Building-Commercial-Addition-NA' }
      record = Accela::RecordAPI.new(config).create_record(input_record)
      expect(record.id).not_to eq nil
    end

    it 'works with requests that require a model object' do
      input_record = Accela::Record.new type: { id: 'Building-Commercial-Addition-NA' },
                                        contacts: [{ type: { text: 'Applicant',
                                                             value: 'Applicant' } }]
      record = Accela::RecordAPI.new(config).create_record(input_record)
      contacts = Accela::RecordAPI.new(record, config).get_all_contacts_for_record
      expect(contacts.first.id).to_not eq nil
    end
  end
end
