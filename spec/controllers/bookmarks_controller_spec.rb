require_relative '../rails_helper'

describe BookmarksController do
  # jquery 1.9 ajax does error callback if 200 returns empty body. so use 204 instead.
  describe 'update' do
    it 'has a 200 status code when creating a new one' do
      xhr :put, :update, id: '2007020969', format: :js
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['bookmarks']['count']).to eq 1
    end

    it 'has a 500 status code when create is not success' do
      allow(@controller).to receive_message_chain(:current_or_guest_user, :existing_bookmark_for).and_return(false)
      allow(@controller).to receive_message_chain(:current_or_guest_user, :persisted?).and_return(true)
      allow(@controller).to receive_message_chain(:current_or_guest_user, :bookmarks, :where, :exists?).and_return(false)
      allow(@controller).to receive_message_chain(:current_or_guest_user, :bookmarks, :create).and_return(false)
      xhr :put, :update, id: 'iamabooboo', format: :js
      expect(response.code).to eq '500'
    end
  end

  describe 'delete' do
    before do
      @controller.send(:current_or_guest_user).save
      @controller.send(:current_or_guest_user).bookmarks.create! document_id: '2007020969', document_type: 'SolrDocument'
    end

    it 'has a 200 status code when delete is success' do
      xhr :delete, :destroy, id: '2007020969', format: :js
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['bookmarks']['count']).to eq 0
    end

    it 'has a 500 status code when delete is not success' do
      bm = double(Bookmark)
      allow(@controller).to receive_message_chain(:current_or_guest_user, :existing_bookmark_for).and_return(bm)
      allow(@controller).to receive_message_chain(:current_or_guest_user, :bookmarks, :find_by).and_return(double('bookmark', delete: nil, destroyed?: false))

      xhr :delete, :destroy, id: 'pleasekillme', format: :js

      expect(response.code).to eq '500'
    end
  end

  describe 'email' do
    doc_ids = ['123456']
    before do
      @controller.send(:current_or_guest_user).save
      @controller.send(:current_or_guest_user).bookmarks.create! document_id: '123456', document_type: 'SolrDocument'
    end

    describe 'email' do
      doc_ids = ['2007020969']
      let(:mock_response) { [double, [SolrDocument.new(id: '2007020969', title_tesim: 'needs a title for this to work')]] }
      before do
        allow(controller).to receive_messages(fetch: mock_response)
      end
      it 'should give error if no TO parameter' do
        post :email, id: doc_ids
        expect(request.flash[:error]).to eq 'You must enter a recipient in order to send this message'
      end
      it 'should give an error if the email address is not valid' do
        post :email, id: doc_ids, to: 'test_bad_email'
        expect(request.flash[:error]).to eq 'You must enter a valid email address'
      end
      it 'should not give error if no Message parameter is set' do
        post :email, id: doc_ids, to: 'test_email@projectblacklight.org'
        expect(request.flash[:error]).to be_nil
      end
      it 'should redirect back to the record upon success' do
        expect do
          post :email, id: doc_ids, to: 'test_email@projectblacklight.org', message: 'xyz'
        end.to change { ActionMailer::Base.deliveries.count }.by(1)
        expect(request.flash[:error]).to be_nil
        expect(request).to redirect_to(bookmarks_path)
      end
      it 'should render email_success for XHR requests' do
        expect do
          xhr :post, :email, id: doc_ids, to: 'test_email@projectblacklight.org', message: 'xyz'
        end.to change { ActionMailer::Base.deliveries.count }.by(1)
        expect(request).to render_template 'email_success'
        expect(request.flash[:success]).to eq 'Email Sent'
      end
    end
  end
end
