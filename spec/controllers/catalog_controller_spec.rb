require_relative "../rails_helper"

describe CatalogController, type: :controller do

  it "should have a collection name" do
    get :index
    expect(assigns(:collection_name)).to eq "all library collections"
  end

  it "should load location table" do
    get :index
    locations = assigns(:locations)
    expect(locations['aginternet']).to eq "Alberta Government Library Internet"
    expect(locations['uascitech']).to eq "University of Alberta Cameron Science & Technology"
  end

  it "should load status table" do
    get :index
    statuses = assigns(:statuses)
    expect(statuses['trad_med']).to eq "traditional medicine"
    expect(statuses['sust_agric']).to eq "sustainable agriculture resource centre"
  end

  it "should load item type table" do
    get :index
    item_types = assigns(:item_types)
    expect(item_types['av']).to eq "audio-visual"
    expect(item_types['mag_media']).to eq "magnetic media"
  end

  it "should contain results in the results viewi (#index)"

  it "should render contain a single record in the show view (#show)"

end
