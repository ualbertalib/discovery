require 'spec_helper'

describe HoldingsHelper do
  describe '#display_ual_shield' do
    HoldingsHelper::UAL_SHIELD_LIBRARIES.each do |library|
      it "should display if #{library}" do
        document = { 'location_tesim' => library }
        expect(helper.display_ual_shield(document)).to be true
      end
    end

    it 'should not display if item is not available on campus' do
      document = {}
      expect(helper.display_ual_shield(document)).to be false
      document = { 'location_tesim' => [] }
      expect(helper.display_ual_shield(document)).to be false
    end
  end

  describe '#request_rcrf_read_on_site_form?' do
    it 'should return true if you can request the item' do
      item = { status: 'READONSITE', location: HoldingsHelper::READ_ON_SITE_LOCATION_RCRF }
      expect(helper.request_rcrf_read_on_site_form?(item)).to be true
    end

    it 'should return false if you cannot request the item' do
      item = { location: HoldingsHelper::READ_ON_SITE_LOCATION_RCRF }
      expect(helper.request_rcrf_read_on_site_form?(item)).to be false
    end
  end

  describe '#request_bpsc_read_on_site_form?' do
    it 'should return true if you can request the item' do
      item = { status: 'READONSITE', location: HoldingsHelper::READ_ON_SITE_LOCATION_BPSC }
      expect(helper.request_bpsc_read_on_site_form?(item)).to be true
    end

    it 'should return false if you cannot request the item' do
      item = { location: HoldingsHelper::READ_ON_SITE_LOCATION_BPSC }
      expect(helper.request_bpsc_read_on_site_form?(item)).to be false
    end
  end

  describe '#request_microform?' do
    it 'should return true if you can request the item' do
      item = { type: 'MICROFORM', location: HoldingsHelper::READ_ON_SITE_LOCATION_RCRF }
      expect(helper.request_microform?(item)).to be true
    end

    it 'should return false if you cannot request the item' do
      item = { location: HoldingsHelper::READ_ON_SITE_LOCATION_RCRF }
      expect(helper.request_microform?(item)).to be false
    end
  end

  let(:marc_display_with_ua_links) do
    File.open(
      Rails.root.join('spec', 'fixtures', 'marc_display_with_ua_links.xml')
    ).read
  end
  let(:marc_display_with_bad_id) do
    File.open(
      Rails.root.join('spec', 'fixtures', 'marc_display_with_bad_id.xml')
    ).read
  end
  let(:marc_display_with_sfx_links) do
    File.open(
      Rails.root.join('spec', 'fixtures', 'marc_display_with_sfx_links.xml')
    ).read
  end
  let(:marc_display_with_print_holdings) do
    File.open(
      Rails.root.join('spec', 'fixtures', 'marc_display_with_print_holdings.xml')
    ).read
  end

  describe 'holdings with items' do
    xit 'should return a set of Symphony print holdings' do
      document = {}
      document['marc_display'] = marc_display_with_print_holdings
      holdings = helper.holdings(document, :items)
      expect(holdings).to be_an_instance_of Array
      expect(holdings.count).to eq 2
      expect(holdings.first[:item_id]).to eq '000043591213'
      expect(holdings.first[:status]).to eq 'ON_SHELF'
      expect(holdings.first[:location]).to eq 'UABARD'
      expect(holdings.first[:type]).to eq 'BOOK'
      expect(holdings.first[:copies]).to eq '1'
      expect(holdings.first[:summary_holdings]).to eq 0
      expect(holdings.first[:public_note]).to eq nil
      expect(holdings.first[:holdable]).to eq 'true'
    end
  end

  describe 'holdings with links' do
    it 'should return a set of Symphony electronic holdings' do
      VCR.use_cassette('holdings_with_links') do
        document = {}
        document['marc_display'] = marc_display_with_ua_links
        holdings = helper.holdings(document, :links)
        expect(holdings).to be_an_instance_of Array
        expect(holdings.first).to be_an_instance_of Hash
        expect(holdings.first).to eq(
          'University of Alberta Access (Unlimited Concurrent Users) from Ebook Central Academic Complete' => 'https://ebookcentral.proquest.com/lib/ualberta/detail.action?docID=1564351',
          'University of Alberta Access (Unlimited Concurrent Users) from EBSCO Academic Collection' => 'http://search.ebscohost.com/login.aspx?direct=true&scope=site&db=e000xna&AN=666223'
        )
      end
    end
  end

  describe '#fetch_sfx_holdings' do
    xit 'should return a set of SFX link URLs' do
      document = double('document')
      allow(document).to receive(:[]).with('marc_display') { marc_display_with_sfx_links }
      allow(document).to receive(:id) { '954921332001' }
      holdings = helper.fetch_sfx_holdings(document)
      expect(holdings).to be_an_instance_of Hash
      expect(holdings.size).to eq 15
      expect(holdings[111_088_000_914_001]).to be_an_instance_of Hash
      expect(holdings[111_088_000_914_001][:name]).to eq 'Gale Cengage CPI.Q'
      expect(holdings[111_088_000_914_001][:url]).to eq 'http://login.ezproxy.library.ualberta.ca/login?url=http://find.galegroup.com/openurl/openurl?res_id=info%3Asid%2Fgale%3ACPI&rft.issn=0000-0019&req_dat=info%3Asid%2Fgale%3Augnid%3Aedmo69826&rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&url_ctx_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Actx&ctx_enc=info%3Aofi%3Aenc%3AUTF-8&url_ver=Z39.88-2004&rft.jtitle=Publishers+Weekly'
    end
  end

  describe 'when given a bad id' do
    it 'should raise an error' do
      document = {}
      document['marc_display'] = marc_display_with_bad_id
      expect { helper.holdings(document, :items) }.to raise_error SymphonyService::Error::InvalidIdError
    end
  end
end
