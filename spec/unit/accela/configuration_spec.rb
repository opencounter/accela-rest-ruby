require_relative '../../spec_helper'

describe Accela::Configuration do
  describe 'initialize' do
    let(:config) do
      Accela::Configuration.new(
        app_id: 'abcd1234',
        app_secret: 'wxzy',
        agency: 'Great Northern Lodge',
        environment: 'TEST'
      )
    end

    it 'accepts settings as a hash' do
      expect(config.app_id).to eq 'abcd1234'
      expect(config.app_secret).to eq 'wxzy'
      expect(config.agency).to eq 'Great Northern Lodge'
      expect(config.environment).to eq 'TEST'
    end
  end

  describe '::app_id' do
    it "raises a ConfigurationError if it hasn't been set" do
      Accela::Configuration.app_id = nil
      expect do
        Accela::Configuration.app_id
      end.to raise_error(Accela::ConfigurationError)
    end
  end

  describe '::app_secret' do
    it "raises a ConfigurationError if it hasn't been set" do
      Accela::Configuration.app_secret = nil
      expect do
        Accela::Configuration.app_secret
      end.to raise_error(Accela::ConfigurationError)
    end
  end

  describe '::agency' do
    it "raises a ConfigurationError if it hasn't been set" do
      Accela::Configuration.agency = nil
      expect do
        Accela::Configuration.agency
      end.to raise_error(Accela::ConfigurationError)
    end
  end

  describe '::environment' do
    it "raises a ConfigurationError if it hasn't been set" do
      Accela::Configuration.environment = nil
      expect do
        Accela::Configuration.environment
      end.to raise_error(Accela::ConfigurationError)
    end
  end
end
