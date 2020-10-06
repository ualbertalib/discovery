require 'rails_helper'

RSpec.describe 'Search sorting', type: :feature do
  scenario 'User can sort by relevance' do
    visit '/catalog'
    fill_in 'q', with: 'shakespeare'
    click_button 'search'

    expect(page).to have_text('Sort by relevance')
    documents = page.all('#documents .document')
    expect(documents[0]).to have_content('Outlines of the life of Shakespeare')
    expect(documents[1]).to have_content('Shakespeare at the Globe : 1599-1609')
    expect(documents[2]).to have_content('Amazing monument : a short history of the Shakespeare industry')
    expect(documents[3]).to have_content('The college Shakespeare; 15 plays and the sonnets')
    expect(documents[4]).to have_content('English drama to 1660; excluding Shakespeare, a guide to information sources')
  end

  scenario 'User can sort by year' do
    visit '/catalog'
    fill_in 'q', with: 'shakespeare'
    click_button 'search'

    find('#sort-dropdown').click
    click_link 'year'

    expect(page).to have_text('Sort by year')
    documents = page.all('#documents .document')
    expect(documents[0]).to have_content('Publication Year: 1986')
    expect(documents[1]).to have_content('Publication Year: 1976')
    expect(documents[2]).to have_content('Publication Year: 1974')
    expect(documents[3]).to have_content('Publication Year: 1974')
    expect(documents[4]).to have_content('Publication Year: 1973')
  end

  scenario 'User can sort by author' do
    visit '/catalog'
    fill_in 'q', with: 'shakespeare'
    click_button 'search'

    find('#sort-dropdown').click
    click_link 'author'

    expect(page).to have_text('Sort by author')
    documents = page.all('#documents .document')
    expect(documents[0]).to have_content('Author: Beckerman, Bernard')
    expect(documents[1]).to have_content('Author: Borgmeier, Raimund')
    expect(documents[2]).to have_content('Author: Brown, Ivor John Carnegie, 1891-1974')
    expect(documents[3]).to have_content('Author: Colie, Rosalie Littell')
  end

  scenario 'User can sort by title' do
    visit '/catalog'
    fill_in 'q', with: 'shakespeare'
    click_button 'search'

    find('#sort-dropdown').click
    click_link 'title'

    expect(page).to have_text('Sort by title')
    documents = page.all('#documents .document')
    expect(documents[0]).to have_content('Amazing monument : a short history of the Shakespeare industry')
    expect(documents[1]).to have_content('Die Bedeutungen des abstrakten substantivierten Adjektivs und des entsprechenden abstrakten Substantivs bei Shakespeare')
    expect(documents[2]).to have_content('The college Shakespeare; 15 plays and the sonnets')
    expect(documents[3]).to have_content('English drama to 1660; excluding Shakespeare, a guide to information sources')
    expect(documents[4]).to have_content('Essays in Shakespearean criticism')
  end
end
