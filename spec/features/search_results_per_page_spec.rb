require 'rails_helper'

RSpec.describe 'Search results per page', type: :feature do
  scenario 'User can change the results per page' do
    visit '/catalog'
    fill_in 'q', with: ' '
    click_button 'search'

    expect(page).to have_text('25 per page')
    expect(page).to have_text('1 - 25')

    find('#per_page-dropdown').click
    click_link '50'

    expect(page).to have_text('50 per page')
    expect(page).to have_text('1 - 50')

    find('#per_page-dropdown').click
    click_link '100'

    expect(page).to have_text('100 per page')
    expect(page).to have_text('1 - 100')
  end
end
