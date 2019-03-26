require 'rails_helper'

describe BookmarksController, type: :controller do

  describe 'email bookmarks' do
    before do
      document = SolrDocument.new(id: "123456", format: ["book"], title_tsim: "The horn", language_ssim: "English", author_tsim: "Janetzky, Kurt")
      @documents = [document]
    end
    it 'return an error message if the email address is not valid' do
        post :email, params: { document_list: @document, to: 'test_bad_email' }
        expect(request.flash[:error]).to eq "You must enter a recipient in order to send this message"
    end

      it "redirects back to the record upon success" do
                allow(RecordMailer).to receive(:email_record)
          .with(anything, { to: 'test_email@projectblacklight.org', message: 'xyz' }, hash_including(host: 'test.host'))
          .and_return double(deliver: nil)
        post :email, params: { document_list: @document, to: 'test_email@projectblacklight.org', message: 'xyz' }
        byebug
        expect(request.flash[:error]).to be_nil
      end
  end
end
