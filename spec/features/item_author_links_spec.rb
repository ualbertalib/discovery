require 'rails_helper'

RSpec.describe 'Item has functioning author links', type: :feature do
  scenario 'User can view and use author links' do
    VCR.use_cassette('item_author_links') do
      visit '/catalog/1002481'

      expect(page).to have_text('Shakespeare at the Globe : 1599-1609')
      expect(page).to have_link('Beckerman, Bernard')
      click_on 'Beckerman, Bernard'
      expect(page).to have_css('.appliedFilter', text: 'Beckerman, Bernard')
      expect(page).to have_text('Shakespeare at the Globe : 1599-1609')
    end
  end
end
