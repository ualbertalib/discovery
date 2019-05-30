require 'rails_helper'

RSpec.describe 'Search clear terms', type: :feature do
  scenario 'User can clear search filter from "You searched for" box' do
    visit '/catalog'
    fill_in 'q', with: ''
    click_button 'search'

    within('.blacklight-electronic_tesim') do
      click_on 'At Library'
    end
    expect(page).to have_css('.appliedFilter', text: 'At Library')

    within('.appliedFilter') do
      find('a.remove').click
    end
    expect(page).to have_no_css('.appliedFilter', text: 'At Library')
  end

  scenario 'User can clear search filter from facets box' do
    visit '/catalog'
    fill_in 'q', with: ''
    click_button 'search'

    within('.blacklight-electronic_tesim') do
      click_on 'At Library'
    end
    expect(page).to have_css('.appliedFilter', text: 'At Library')

    within('.blacklight-electronic_tesim') do
      find('a.remove').click
    end
    expect(page).to have_no_css('.appliedFilter', text: 'At Library')
  end

  scenario 'User can clear search query from "You searched for" box' do
    visit '/catalog'
    fill_in 'q', with: 'query'
    click_button 'search'

    expect(page).to have_css('.appliedFilter', text: 'query')
    within('.appliedFilter') do
      find('a.remove').click
    end
    expect(page).to not_have_css('.appliedFilter', text: 'query')
  end

  scenario 'User can clear search query from search box' do
    visit '/catalog'
    fill_in 'q', with: 'query'
    click_button 'search'

    expect(page).to have_css('.appliedFilter', text: 'query')
    fill_in 'q', with: ''
    click_button 'search'
    expect(page).to not_have_css('.appliedFilter', text: 'query')
  end

  scenario 'User can clear search query from "start over" link' do
    visit '/catalog'
    fill_in 'q', with: 'query'
    click_button 'search'

    expect(page).to have_css('.appliedFilter', text: 'query')
    click_link 'Start Over'
    expect(page).to not_have_css('.appliedFilter', text: 'query')
  end

end
