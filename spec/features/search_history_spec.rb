require 'rails_helper'

RSpec.feature 'Search history test', type: :feature do
  scenario 'User wants to see their search history' do
    visit '/catalog'
    fill_in 'q', with: 'accountancy'
    click_button 'search'
    visit '/search_history'
    expect(page).to have_text('Search History')
    expect(page).to have_text('Keyword:accountancy')
  end

  scenario 'User wants to clear their search history' do
    visit '/catalog'
    fill_in 'q', with: 'accountancy'
    click_button 'search'
    visit '/search_history'
    expect(page).to have_text('Search History')
    expect(page).to have_text('Keyword:accountancy')

    click_link 'Clear Search History'
    page.driver.browser.switch_to.alert.accept
    expect(page).to have_text 'You have no search history'
    expect(page).not_to have_text('Keyword:accountancy')
  end
end
