require_relative "../rails_helper"

describe EbooksController, type: :controller do

  it "should have a collection name" do
    get :index
    expect(assigns(:collection_name)).to eq "electronic books"
  end


end
