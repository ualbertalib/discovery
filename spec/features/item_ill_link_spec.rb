require 'rails_helper'

RSpec.describe 'Link to ill', type: :feature do
  scenario 'Sfx item has link to ill' do
    VCR.use_cassette('item_ill_link') do
      visit '/catalog/954921333007'

      expect(page).to have_link('ill', href: %r{https://license-terms.library.ualberta.ca\/terms\/})
    end
  end

  scenario 'Non-sfx item does not have link to ill' do
    VCR.use_cassette('item_no_ill_link') do
      visit '/catalog/1002481'

      expect(page).not_to have_link('ill', href: %r{https://license-terms.library.ualberta.ca\/terms\/})
    end
  end
end
