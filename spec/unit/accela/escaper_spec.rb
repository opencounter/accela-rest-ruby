require_relative '../../spec_helper'

describe Accela::Escaper do
  let(:escaper) do
    Object.new.extend(Accela::Escaper)
  end

  describe '#escape' do
    it "escapes URIs according to Accela's spec" do
      input = 'ServiceRequest-Streets and Sidewalks-Snow Removal-NA'
      expected = 'ServiceRequest.1Streets.cand.cSidewalks.1Snow.cRemoval.1NA'
      expect(escaper.escape(input)).to eq expected
    end
  end
end
