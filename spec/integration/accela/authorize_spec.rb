require_relative '../spec_helper'

describe Accela::Authorize, :vcr do
  let(:app_id) { '638853549908464776' }
  let(:app_secret) { '4588a663f51143e69432e2734143e44b' }
  let(:agency) { 'nullisland' }
  let(:environment) { 'TEST' }
  let(:username) { 'developer' }
  let(:password) { 'accela' }
  let(:scope) { 'records addresses' }

  let(:config) do
    Accela::Configuration.new(
      app_id: app_id,
      app_secret: app_secret,
      agency: agency,
      environment: environment
    )
  end

  let(:auth) { Accela::Authorize.new(config) }
  let(:token) { auth.login(username, password, scope) }

  context 'valid credentials' do
    it 'returns an access token, a refresh token and additional information' do
      expect(token.access_token).to be_truthy
      expect(token.token_type).to be_truthy
      expect(token.expires_in).to be_truthy
      expect(token.refresh_token).to be_truthy
      expect(token.scope).to be_truthy
    end
  end

  context 'invalid credentials' do
    let(:password) { 'oops' }
    it 'raises authorization exception' do
      expect { token }.to raise_error Accela::AuthorizationError
    end
  end

  describe 'use refresh token to get a new access token' do
    let(:new_token) { auth.refresh(token.refresh_token) }

    it 'returns an access token, a refresh token and additional information' do
      expect(new_token.access_token).to_not eq(token.access_token)

      expect(new_token.access_token).to be_truthy
      expect(new_token.token_type).to be_truthy
      expect(new_token.expires_in).to be_truthy
      expect(new_token.refresh_token).to be_truthy
      expect(new_token.scope).to be_truthy
    end
  end
end
