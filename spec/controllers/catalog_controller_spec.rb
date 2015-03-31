require "rails_helper"

describe CatalogController, type: :controller do

  it "should have a collection name" do
    get :index
    expect(assigns(:collection_name)).to eq "all library collections"
  end

  it "should load location table" do
    get :index
    locations = assigns(:locations)
    expect(locations['aginternet']).to eq "Alberta Government Library - Internet"
    expect(locations['uascitech']).to eq "University of Alberta Cameron - Science & Technology"
  end

  it "should load status table" do
    get :index
    statuses = assigns(:statuses)
    expect(statuses['trad_med']).to eq "traditional medicine"
    expect(statuses['sust_agric']).to eq "sustainable agriculture resource centre"
  end
end
