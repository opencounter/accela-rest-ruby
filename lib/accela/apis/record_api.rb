module Accela
  class RecordAPI < APIGroup
    as_class_method :get_records, :get_all_records, :create_record,
                    :get_all_contacts_for_record, :create_record_fees,
                    :create_record_contacts, :update_record_custom_forms,
                    :update_record_custom_tables, :create_partial_record, :update_record,
                    :update_record_contact, :finalize_record, :create_record_addresses,
                    :update_record_address, :get_record_custom_tables, :get_record,
                    :search_records, :get_records_of_type, :create_record_documents,
                    :update_record_contact_custom_forms, :update_record_contact_custom_tables

    def create_record(input)
      raw = input.is_a?(Hash) ? input : input.raw
      payload = RecordTranslator.ruby_to_json([raw])
      record_hash = Accela::V4::CreateRecord.new(config).result(payload.first)
      input_hash = RecordTranslator.json_to_ruby([record_hash]).first
      Record.create(input_hash)
    end

    def create_partial_record(input)
      raw = input.is_a?(Hash) ? input : input.raw
      payload = RecordTranslator.ruby_to_json([raw])
      record_hash = Accela::V4::CreatePartialRecord.new(config).result(payload.first)
      input_hash = RecordTranslator.json_to_ruby([record_hash]).first
      Record.create(input_hash)
    end

    def update_record(id, input)
      raw = input.is_a?(Hash) ? input : input.raw
      payload = RecordTranslator.ruby_to_json([raw])
      record_hash = Accela::V4::UpdateRecord.new(config).result(id, payload.first)
      input_hash = RecordTranslator.json_to_ruby([record_hash]).first
      Record.create(input_hash)
    end

    def finalize_record(record_id, payload = :empty_object)
      record_hash = Accela::V4::FinalizeRecord.new(config).result(record_id, payload)
      input_hash = RecordTranslator.json_to_ruby([record_hash]).first
      Record.create(input_hash)
    end

    def get_records(*args)
      fetch_many(Accela::V4::GetRecords,
                 RecordTranslator,
                 Record,
                 *args)
    end

    def get_all_records(opts = {})
      fetch_many(Accela::V4::GetAllRecords,
                 RecordTranslator,
                 Record,
                 opts)
    end

    def get_all_addresses_for_record
      fetch_has_many(Accela::V4::GetAllAddressesForRecord,
                     AddressTranslator,
                     Address)
    end

    def get_all_contacts_for_record
      fetch_has_many(Accela::V4::GetAllContactsForRecord,
                     ContactTranslator,
                     Contact)
    end

    def get_all_owners_for_record
      fetch_has_many(Accela::V4::GetAllOwnersForRecord,
                     OwnerTranslator,
                     Owner)
    end

    def get_all_parcels_for_record
      fetch_has_many(Accela::V4::GetAllParcelsForRecord,
                     ParcelTranslator,
                     Parcel)
    end

    def get_all_record_types
      fetch_many(Accela::V4::GetAllRecordTypes,
                 TypeTranslator,
                 Type)
    end

    def get_record_related(*args)
      fetch_has_many(Accela::V4::GetRecordsRelated,
                     RecordIdTranslator,
                     RecordId,
                     *args)
    end

    def create_record_fees(record_id, input)
      raw = input.is_a?(Hash) ? input : input.raw
      payload = FeeTranslator.ruby_to_json([raw])
      fee_hash = Accela::V4::CreateRecordFees.new(config).result(record_id, payload.first)
      input_hash = FeeTranslator.json_to_ruby([fee_hash]).first
      Fee.create(input_hash)
    end

    def update_record_custom_forms(id, input)
      Accela::V4::UpdateRecordCustomForms.new(config).result(id, input)
    end

    def update_record_custom_tables(id, input)
      Accela::V4::UpdateRecordCustomTables.new(config).result(id, input)
    end

    def create_record_contacts(record_id, input)
      raw = input.map { |contact| contact.is_a?(Hash) ? contact : contact.raw }
      payload = ContactTranslator.ruby_to_json(raw)
      Accela::V4::CreateRecordContacts.new(config).result(record_id, payload)
    end

    def update_record_contact_custom_forms(record_id, contact_id, forms)
      Accela::V4::UpdateRecordContactCustomForms.new(config).result(record_id, contact_id, forms)
    end

    def update_record_contact_custom_tables(record_id, contact_id, tables)
      Accela::V4::UpdateRecordContactCustomTables.new(config).result(record_id, contact_id, tables)
    end

    def update_record_contact(record_id, id, input)
      raw = input.is_a?(Hash) ? input : input.raw
      payload = ContactTranslator.ruby_to_json([raw])
      Accela::V4::UpdateRecordContact.new(config).result(record_id, id, payload.first)
    end

    def create_record_addresses(record_id, input)
      raw = input.map { |address| address.is_a?(Hash) ? address : address.raw }
      payload = AddressTranslator.ruby_to_json(raw)
      Accela::V4::CreateRecordAddresses.new(config).result(record_id, payload)
    end

    def update_record_address(record_id, id, input)
      raw = input.is_a?(Hash) ? input : input.raw
      payload = AddressTranslator.ruby_to_json([raw])
      Accela::V4::UpdateRecordAddress.new(config).result(record_id, id, payload.first)
    end

    def get_record_custom_tables(id)
      Accela::V4::GetRecordCustomTables.new(config).result(id)
    end

    def get_record(id)
      payload = {
        id: id
      }
      params = { expand: 'addresses,contacts,customForms,customTables' }
      Array(search_records(params, payload)).first
    end

    def get_records_of_type(type)
      payload = {
        module: type.split('-', 2).first,
        type: { id: type }
      }
      params = { expand: 'addresses,contacts,customForms,customTables' }
      Array(search_records(params, payload))
    end

    def search_records(params, payload)
      Accela::V4::SearchRecords.new(config).result(params, payload)
    end

    def create_record_documents(record_id:, file:, filename:, content_type:, description: '')
      filename = "#{filename}.#{content_type.split('/').last}"
      agency = config.agency == 'CHARLOTTE_EC' ? 'CHARLOTTE' : config.agency
      payload = {
        uploadedFile: Faraday::UploadIO.new(file, content_type, filename),
        fileInfo: <<-JSON.strip_heredoc
          [{
            "serviceProviderCode": "#{agency}",
            "fileName": "#{filename}",
            "type": "#{content_type}",
            "description": "#{description}"
          }]
        JSON
      }
      Accela::V4::CreateRecordDocuments.new(config).result(record_id, payload)
    end
  end
end
