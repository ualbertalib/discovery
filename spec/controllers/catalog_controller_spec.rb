require "rails_helper"

describe CatalogController, type: :controller do

  it "should have a collection name" do
    get :index
    expect(assigns(:collection_name)).to eq "all library collections"
  end

  it "should load status and location tables"

end
