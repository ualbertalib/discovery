require_relative "../spec_helper.rb"

include E
include HoldingsHelper

describe HoldingsHelper do
  let(:marc_display_with_ua_links){ File.open(E::*("fixtures/marc_display_with_ua_links.xml")).read }
  let(:marc_display_with_bad_id){ File.open(E::*("fixtures/marc_display_with_bad_id.xml")).read }
  let(:marc_display_with_sfx_links){ File.open(E::*("fixtures/marc_display_with_sfx_links.xml")).read }
  let(:marc_display_with_print_holdings){ File.open(E::*("fixtures/marc_display_with_print_holdings.xml")).read }

  describe "holdings with items" do
    it "should return a set of Symphony print holdings" do
      document = {}
      document['marc_display'] = marc_display_with_print_holdings
      holdings = holdings(document, :items)
      expect(holdings).to be_an_instance_of Array
      expect(holdings.count).to eq 2
      expect(holdings.first[:item_id]).to eq "000043591213"
      expect(holdings.first[:status]).to eq "ON_SHELF"
      expect(holdings.first[:location]).to eq "UABARD"
      expect(holdings.first[:type]).to eq "BOOK"
      expect(holdings.first[:copies]).to eq "1"
      expect(holdings.first[:summary_holdings]).to eq 0
      expect(holdings.first[:public_note]).to eq nil
      expect(holdings.first[:holdable]).to eq "true"
    end
  end

  describe "holdings with links" do
    it "should return a set of Symphony electronic holdings" do
      document = {}
      document['marc_display'] = marc_display_with_ua_links
      holdings = holdings(document, :links)
      expect(holdings).to be_an_instance_of Array
      expect(holdings.first).to be_an_instance_of Hash
      expect(holdings.first).to eq({"University of Alberta Access (6 Concurrent Users)"=>"http://proquest.safaribooksonline.com/?uiCode=ualberta&xmlId=9781785283642"})
    end
  end

  describe "#fetch_sfx_holdings" do
    it "should return a set of SFX link URLs" do
      document = double("document")
      allow(document).to receive(:[]).with('marc_display'){ marc_display_with_sfx_links }
      allow(document).to receive(:id){ "954921332001" }
      holdings = fetch_sfx_holdings(document)
      expect(holdings).to be_an_instance_of Hash
      expect(holdings.size).to eq 15
      expect(holdings[111088000914001]).to be_an_instance_of Hash
      expect(holdings[111088000914001][:name]).to eq "Gale Cengage CPI.Q"
      expect(holdings[111088000914001][:url]).to eq "http://login.ezproxy.library.ualberta.ca/login?url=http://find.galegroup.com/openurl/openurl?res_id=info%3Asid%2Fgale%3ACPI&rft.issn=0000-0019&req_dat=info%3Asid%2Fgale%3Augnid%3Aedmo69826&rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&url_ctx_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Actx&ctx_enc=info%3Aofi%3Aenc%3AUTF-8&url_ver=Z39.88-2004&rft.jtitle=Publishers+Weekly"

    end

  end

  describe "when given a bad id" do
    it "should raise an error" do
      document = {}
      document['marc_display'] = marc_display_with_bad_id
      expect { holdings(document, :items) }.to raise_error
    end
  end
end
