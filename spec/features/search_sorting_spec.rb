require 'rails_helper'

RSpec.describe 'Search sorting', type: :feature do
  scenario 'User can sort by relevance' do
    visit '/catalog'
    fill_in 'q', with: 'shakespeare'
    click_button 'search'

    expect(page).to have_text('Sort by relevance')
    documents = page.all("#documents .document")
    documents[0].should have_content('Outlines of the life of Shakespeare')
    documents[1].should have_content('Shakespeare at the Globe : 1599-1609')
    documents[2].should have_content('Amazing monument : a short history of the Shakespeare industry')
    documents[3].should have_content('The college Shakespeare; 15 plays and the sonnets')
    documents[4].should have_content('English drama to 1660; excluding Shakespeare, a guide to information sources')
  end

  scenario 'User can sort by year' do
    visit '/catalog'
    fill_in 'q', with: 'shakespeare'
    click_button 'search'

    find('#sort-dropdown').click
    click_link 'year'

    expect(page).to have_text('Sort by year')
    documents = page.all("#documents .document")
    documents[0].should have_content('William Shakespeare, the complete works, Original-spelling ed.')
    documents[1].should have_content('English drama to 1660; excluding Shakespeare, a guide to information sources')
    documents[2].should have_content('Pitchman\'s melody: Shaw about "Shakespear."')
    documents[3].should have_content('Some facets of King Lear; essays in prismatic criticism')
    documents[4].should have_content('Die Bedeutungen des abstrakten substantivierten Adjektivs und des entsprechenden abstrakten Substantivs bei Shakespeare')
  end

  scenario 'User can sort by author' do
    visit '/catalog'
    fill_in 'q', with: 'shakespeare'
    click_button 'search'

    find('#sort-dropdown').click
    click_link 'author'

    expect(page).to have_text('Sort by author')
    documents = page.all("#documents .document")
    documents[0].should have_content('Shakespeare at the Globe : 1599-1609')
    documents[1].should have_content('Shakespeare Sonett, "When forty winters" ... und die deutschen Übersetzer; Untersuchungen zu den Problemen der Shakespeare-Übertragung')
    documents[2].should have_content('Amazing monument : a short history of the Shakespeare industry')
    documents[3].should have_content('Some facets of King Lear; essays in prismatic criticism')
    documents[4].should have_content('Essays in Shakespearean criticism')
  end

  scenario 'User can sort by title' do
    visit '/catalog'
    fill_in 'q', with: 'shakespeare'
    click_button 'search'

    find('#sort-dropdown').click
    click_link 'title'

    expect(page).to have_text('Sort by title')
    documents = page.all("#documents .document")
    documents[0].should have_content('Amazing monument : a short history of the Shakespeare industry')
    documents[1].should have_content('Die Bedeutungen des abstrakten substantivierten Adjektivs und des entsprechenden abstrakten Substantivs bei Shakespeare')
    documents[2].should have_content('The college Shakespeare; 15 plays and the sonnets')
    documents[3].should have_content('English drama to 1660; excluding Shakespeare, a guide to information sources')
    documents[4].should have_content('Essays in Shakespearean criticism')
  end
end
