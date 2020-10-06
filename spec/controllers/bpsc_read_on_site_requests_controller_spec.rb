require 'rails_helper'

RSpec.describe BPSCReadOnSiteRequestsController, type: :controller do
  it 'should render new form' do
    get :new
    expect(response).to have_http_status(:success)
  end

  it 'should create new request' do
    expect do
      post :create, bpsc_read_on_site_request: {
        name: 'Jane Doe',
        email: 'jane_doe@ualberta.ca',
        appointment_time: 'January 1st at 1 PM',
        title: 'The death of Archie',
        call_number: 'AB 123.4 A123 1234',
        item_url: 'https://library.ualberta.ca/catalog/8081552'
      }
    end.to change { ActionMailer::Base.deliveries.count }.by(1)

    expect(response).to redirect_to(root_path)
    expect(flash[:success]).to match(I18n.t('request_form_success'))
  end
end
