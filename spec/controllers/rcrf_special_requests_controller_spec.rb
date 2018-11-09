require 'rails_helper'

RSpec.describe RCRFSpecialRequestsController, type: :controller do
  it 'should render new form' do
    get :new
    expect(response).to have_http_status(:success)
  end

  it 'should create new request' do
    expect do
      post :create, rcrf_special_request: {
        name: 'Jane Doe',
        email: 'jane_doe@ualberta.ca',
        title: 'The death of Archie',
        item_url: 'https://library.ualberta.ca/catalog/8081552',
        notes: 'Would like to request a visit to view this item on January 1st around 1 PM',
        library: 'University of Alberta Augustana'
      }
    end.to change { ActionMailer::Base.deliveries.count }.by(1)

    expect(response).to redirect_to(root_path)
    expect(flash[:success]).to match(I18n.t('request_form_success'))
  end
end
