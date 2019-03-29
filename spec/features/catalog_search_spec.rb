require 'rails_helper'

RSpec.describe 'Catalog Search', type: :feature do
  scenario 'User searches the catalog' do
    visit '/catalog'

    fill_in 'q', with: 'shakespeare'
    click_button 'search'

    expect(page).to have_text('Results for shakespeare')
  end

  scenario 'User visits an item result' do
    VCR.use_cassette('item_result') do
      visit 'catalog/1001523'
      expect(page).to have_text('Shakespeare : a historical and critical study with annotated texts of twenty-one plays')
    end
  end

  scenario 'User visits an SFX item result' do
    VCR.use_cassette('sfx_result') do
      visit 'catalog/954921333008'
      expect(page).to have_text('Accountancy') # title
      expect(page).to have_link('Business Source Complete') # Subscription
      expect(page).to have_link('Factiva') # Subscription
    end
  end
end
