require 'rails_helper'

RSpec.describe 'Search results google book jackets', type: :feature do
  scenario 'Search results with an isbn have a google book jacket' do
    visit '/'

    fill_in 'q', with: 'Savages; a film'
    click_button 'search'

    page.assert_selector('#documents .document', count: 1)
    expect(page).to have_css("img[src*='https://books.google.com/books?vid=ISBN']")
  end

  scenario 'Search results without an isbn do not have a google book jacket' do
    visit '/'

    fill_in 'q', with: 'The college Shakespeare; 15 plays and the sonnets'
    click_button 'search'

    page.assert_selector('#documents .document', count: 1)
    expect(page).not_to have_css("img[src*='https://books.google.com/books?vid=ISBN']")
  end
end
