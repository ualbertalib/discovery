require_relative "../rails_helper"

describe JournalsController, type: :controller do

  it "should have a collection name" do
    get :index
    expect(assigns(:collection_name)).to eq "e-Journals"
  end


end