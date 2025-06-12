require_relative '../../spec_helper'

describe Accela::RecordTranslator do
  let(:translator) { Accela::RecordTranslator.new }

  describe '#json_to_ruby' do
    let(:input) do
      [
        {
          'balance' => 123.45,
          'assignedUser' => 'Dale Cooper',
          'publicOwned' => false
        }
      ]
    end

    let(:result) { translator.json_to_ruby(input) }

    it 'translates from a json hash to a ruby hash' do
      expected = [{
        balance: 123.45,
        assigned_user: 'Dale Cooper',
        public_owned: false
      }]

      expect(result).to eq expected
    end

    context 'input contains date' do
      let(:input) do
        [
          {
            'appearanceDate' => '2014-08-18 12:00:00'
          }
        ]
      end

      it 'translates to a ruby date object' do
        expected = [{
          appearance_date: DateTime.parse('2014-08-18 12:00:00')
        }]

        expect(result).to eq expected
      end
    end

    context 'payload contains keys not in translation table' do
      let(:input) do
        [
          {
            'balance' => 123.45,
            'newProperty' => false,
            'assignedUser' => 'Dale Cooper',
            'anotherNewProprty' => 'Test',
            'publicOwned' => false
          }
        ]
      end

      it 'quarantines these key/vals under other key' do
        expected = [{
          balance: 123.45,
          assigned_user: 'Dale Cooper',
          public_owned: false
        }]

        expect(result).to eq expected
      end
    end

    context 'input contains date' do
      let(:input) do
        [
          {
            'balance' => 123.45,
            'type' => {
              'text' => 'This is a text',
              'value' => 'Value discounts',
              'subType' => 'Nuclear'
            }
          }
        ]
      end

      it 'translates to a ruby date object' do
        expected = [{
          balance: 123.45,
          type: {
            text: 'This is a text',
            value: 'Value discounts',
            sub_type: 'Nuclear'
          }
        }]

        expect(result).to eq expected
      end
    end
  end

  describe '#ruby_to_json' do
    let(:input) do
      [{
        balance: 123.45,
        assigned_user: 'Dale Cooper',
        public_owned: false
      }]
    end

    let(:result) { translator.ruby_to_json(input) }

    it 'translates from a json hash to a ruby hash' do
      expected = [{
        'balance' => 123.45,
        'assignedUser' => 'Dale Cooper',
        'publicOwned' => false
      }]

      expect(result).to eq expected
    end

    context 'input contains date' do
      let(:input) do
        [
          {
            appearance_date: DateTime.parse('2014-08-18 12:00:00')
          }
        ]
      end

      it 'translates to a ruby date object' do
        expected = [{
          'appearanceDate' => '2014-08-18 12:00:00'
        }]

        expect(result).to eq expected
      end
    end

    context 'input contains date' do
      let(:input) do
        [
          {
            balance: 123.45,
            type: {
              text: 'This is a text',
              value: 'Value discounts',
              sub_type: 'Nuclear'
            }
          }
        ]
      end

      it 'translates to a ruby date object' do
        expected = [{
          'balance' => 123.45,
          'type' => {
            'text' => 'This is a text',
            'value' => 'Value discounts',
            'subType' => 'Nuclear'
          }
        }]

        expect(result).to eq expected
      end
    end

    context 'input includes a has_many relation' do
      let(:input) do
        [
          {
            balance: 123.45,
            addresses: [{
              city: 'Cleveland',
              county: 'Cuyahoga'
            }, {
              city: 'Bainbridge Township',
              county: 'Geauga'
            }]
          }
        ]
      end

      it 'translates the has_many' do
        expected = [{
          'balance' => 123.45,
          'addresses' => [{
            'city' => 'Cleveland',
            'county' => 'Cuyahoga'
          }, {
            'city' => 'Bainbridge Township',
            'county' => 'Geauga'
          }]
        }]

        expect(result).to eq expected
      end
    end
  end
end
