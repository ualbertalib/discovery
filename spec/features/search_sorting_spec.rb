require 'rails_helper'

RSpec.describe 'Search sorting', type: :feature do
  scenario 'User can sort by year' do
    visit '/catalog'
    fill_in 'q', with: 'shakespeare'
    click_button 'search'

    find('#sort-dropdown').click
    click_link 'year'

    expect(page).to have_text('Sort by year')
    expect(first('#documents .document.blacklight-book')).to have_text("William Shakespeare, the complete works, Original-spelling ed.")
  end

  scenario 'User can sort by author' do
    visit '/catalog'
    fill_in 'q', with: 'shakespeare'
    click_button 'search'

    find('#sort-dropdown').click
    click_link 'author'

    expect(page).to have_text('Sort by author')
    expect(first('#documents .document.blacklight-book')).to have_text("Shakespeare at the Globe : 1599-1609")
  end

  scenario 'User can sort by title' do
    visit '/catalog'
    fill_in 'q', with: 'shakespeare'
    click_button 'search'

    find('#sort-dropdown').click
    click_link 'title'

    expect(page).to have_text('Sort by title')
    expect(first('#documents .document.blacklight-book')).to have_text("Amazing monument : a short history of the Shakespeare industry")
  end

end
