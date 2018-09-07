require_relative "../rails_helper"

describe ArticlesController, type: :controller do

  it "should not have a collection name" do
    get :index
    expect(response).to have_http_status(:success)
    expect(assigns(:collection_name)).to eq nil
  end

end
