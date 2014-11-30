require_relative "../spec_helper.rb"

include E
include Holdings

describe Holdings do
  let(:marc_display_with_ua_links){ File.open(E::*("fixtures/marc_display_with_ua_links.xml")).read }
  let(:marc_display_with_sfx_links){ File.open(E::*("fixtures/marc_display_with_sfx_links.xml")).read }

  it "should return a set of Symphony print holdings" #do
    # There are no print books in this small dataset. I need to get one with print holdings to write this test. 
   # document = {}
   # document['marc_display'] = marc_display_with_print_holdings
   # holdings = fetch_symphony_holdings(document)
   # expect(holdings).to be_an_instance_of Array
   # expect(holdings.size).to eq 1
  #end

  it "should return a set of UA link URLs" do
    document = {}
    document['marc_display'] = marc_display_with_ua_links
    urls = create_ua_links(document)
    expect(urls).to be_an_instance_of Array
    expect(urls.size).to eq 1
    expect(urls.first[:display]).to eq "University of Alberta Access"
    expect(urls.first[:url]).to eq "http://site.ebrary.com/lib/ualberta/Doc?id=2000743"
  end

  it "should return a set of alternative link URLs" do
    document = {}
    document['marc_display'] = marc_display_with_ua_links
    urls = create_alternative_links(document)
    expect(urls).to be_an_instance_of Array
    expect(urls.size).to eq 5
    expect(urls.first[:display]).to eq "Grant MacEwan University Access"
    expect(urls.first[:url]).to eq "http://site.ebrary.com/lib/macewan/Doc?id=2000743"
  end

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
