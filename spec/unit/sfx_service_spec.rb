require_relative '../spec_helper.rb'

# This needs to use a mock, not hit SFX directly.

include MarcModule

describe SFXService do
  before do
    @document = double('document', id: '110978984569589', :[] => %(<?xml version=\"1.0\" encoding=\"UTF-8\"?><collection xmlns=\"http://www.loc.gov/MARC21/slim\"><record><leader>00000nas-a2200000z--4500</leader><controlfield tag=\"008\">150309uuuuuuuuuxx-uu-|------u|----|eng-d</con    trolfield><datafield tag=\"245\" ind1=\" \" ind2=\"0\"><subfield code=\"a\">Manual of European Environmental Policy</subfield></datafield><datafield tag=\"210\" ind1=\" \" ind2=\" \"><subfield code=\"a\">MANUAL OF ENVIRONMENTAL POLIC    Y</subfield></datafield><datafield tag=\"260\" ind1=\" \" ind2=\" \"><subfield code=\"b\">Earthscan</subfield></datafield><datafield tag=\"022\" ind1=\" \" ind2=\" \"><subfield code=\"a\">1467-0445</subfield></datafield><datafield ta    g=\"776\" ind1=\" \" ind2=\" \"><subfield code=\"x\">1740-3529</subfield></datafield><datafield tag=\"090\" ind1=\" \" ind2=\" \"><subfield code=\"a\">110978984569589</subfield></datafield><datafield tag=\"866\" ind1=\" \" ind2=\" \"    ><subfield code=\"a\">Available in 2013. </subfield><subfield code=\"s\">1000000000002894</subfield><subfield code=\"t\">1000000000002211</subfield><subfield code=\"x\">Taylor & Francis Fresh Journals Collection 2013:Full Text</subfield><subfield code=\"z\">3460000000186734</subfield></datafield></record></collection>))
  end

  xit 'should return a list of targets' do
    s = SFXService.new(@document).targets

    expect(s).to eq Hash[1_000_000_000_002_894 => { id: 1_000_000_000_002_894, coverage: 'Available in 2013. ' }]
    expect(s[1_000_000_000_002_894][:id]).to eq 1_000_000_000_002_894
    expect(s[1_000_000_000_002_894][:coverage]).to eq 'Available in 2013. '
  end

  describe 'timeout handling' do
    before do
      allow(OpenURI).to receive(:open_uri) { raise Timeout::Error }
    end

    it { expect { SFXService.new(@document) }.to raise_error SFXService::Error::HTTPError }
  end
  describe 'http error handling' do
    before do
      allow(OpenURI).to receive(:open_uri) { raise OpenURI::HTTPError.new('', nil) }
    end

    it { expect { SFXService.new(@document) }.to raise_error SFXService::Error::HTTPError }
  end
  describe 'other error handling' do
    before do
      allow(OpenURI).to receive(:open_uri) { raise Exception }
    end

    it { expect { SFXService.new(@document) }.to raise_error Exception }
  end
end
