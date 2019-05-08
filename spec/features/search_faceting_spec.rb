require 'rails_helper'

RSpec.describe 'Search faceting', type: :feature do
  scenario 'User can click more to view all facets' do
    visit '/catalog'
    fill_in 'q', with: 'all'
    click_button 'search'

    expect(page).to have_no_text('H - Social Sciences')
    click_on 'Call Number'
    expect(page).to have_text('H - Social Sciences')

    expect(page).to have_no_text('T - Technology')
    within('.blacklight-lc_1letter_facet') do
      click_on 'more'
    end
    expect(page).to have_text('T - Technology')
  end

  scenario 'User can utilize the more modal' do
    visit '/catalog'

    fill_in 'q', with: 'all'
    click_button 'search'

    click_on 'Subject'
    expect(page).to have_text('Acting')
    expect(page).to have_no_text('Environnement')
    expect(page).to have_no_text('Monologues')
    within('.blacklight-subject_topic_facet') do
      click_on 'more'
    end

    expect(page).to have_text('Human Ecology')
    click_on 'A-Z Sort'
    expect(page).to have_no_text('Human Ecology')

    expect(page).to have_text('Acting')
    expect(page).to have_no_text('Environnement')
    expect(page).to have_no_text('Monologues')

    click_on 'Next »'
    expect(page).to have_no_text('Acting')
    expect(page).to have_text('Environnement')
    expect(page).to have_no_text('Monologues')

    click_on 'Next »'
    expect(page).to have_no_text('Acting')
    expect(page).to have_no_text('Environnement')
    expect(page).to have_text('Halloween')

    click_button '×'
    expect(page).to have_no_text('Monologues')
  end

  scenario 'User can use access facets' do
    visit '/catalog'
    fill_in 'q', with: 'business accounting'
    click_button 'search'
    expect(page).to have_text('Accounting and business research')
    expect(page).to have_text('Disclosure supplement for real estate ventures')

    within('.blacklight-electronic_tesim') do
      click_on 'At Library'
    end
    expect(page).to have_no_text('Accounting and business research')
    expect(page).to have_text('Disclosure supplement for real estate ventures')
    expect(page).to have_css('.appliedFilter', text: 'At Library')
  end

  scenario 'User can use institution facets' do
    visit '/catalog'
    fill_in 'q', with: 'shakespeare'
    click_button 'search'

    click_on 'Institution'
    expect(page).to have_text('Outlines of the life of Shakespeare')
    expect(page).to have_text('Shakespeare at the Globe : 1599-1609')
    expect(page).to have_text('Some facets of King Lear; essays in prismatic criticism')

    within('.blacklight-institution_tesim') do
      click_on 'Burman University'
    end
    expect(page).to have_no_text('Outlines of the life of Shakespeare')
    expect(page).to have_text('Shakespeare at the Globe : 1599-1609')
    expect(page).to have_text('Some facets of King Lear; essays in prismatic criticism')
    expect(page).to have_css('.appliedFilter', text: 'Burman University')

    within('.blacklight-institution_tesim') do
      click_on 'Concordia University of Edmonton'
    end
    expect(page).to have_no_text('Outlines of the life of Shakespeare')
    expect(page).to have_no_text('Shakespeare at the Globe : 1599-1609')
    expect(page).to have_text('Some facets of King Lear; essays in prismatic criticism')
    expect(page).to have_css('.appliedFilter', text: 'Burman University')
    expect(page).to have_css('.appliedFilter', text: 'Concordia University of Edmonton')
  end

  scenario 'User can use library facets' do
    visit '/catalog'
    fill_in 'q', with: 'business accounting'
    click_button 'search'

    click_on 'Library'
    expect(page).to have_text('Accounting and business research')
    expect(page).to have_text('New ideals in business, an account of their practice and their effects upon men and profits')

    within('.blacklight-location_tesim') do
      click_on 'University of Alberta Internet'
    end
    expect(page).to have_no_text('New ideals in business, an account of their practice and their effects upon men and profits')
    expect(page).to have_text('Accounting and business research')
    expect(page).to have_css('.appliedFilter', text: 'University of Alberta Internet')
  end

  scenario 'User can use call number facets' do
    visit '/catalog'
    fill_in 'q', with: 'business accounting'
    click_button 'search'

    click_on 'Call Number'
    expect(page).to have_text('Accounting and business research')
    expect(page).to have_text('New ideals in business, an account of their practice and their effects upon men and profits')

    within('.blacklight-lc_1letter_facet') do
      click_on 'H - Social Sciences'
    end
    expect(page).to have_no_text('Accounting and business research')
    expect(page).to have_text('New ideals in business, an account of their practice and their effects upon men and profits')
    expect(page).to have_css('.appliedFilter', text: 'H - Social Sciences')
  end

  scenario 'User can use format facets' do
    visit '/catalog'
    fill_in 'q', with: 'business accounting'
    click_button 'search'

    click_on 'Format'
    expect(page).to have_text('New ideals in business, an account of their practice and their effects upon men and profits')
    expect(page).to have_text('Accounting and business research')

    within('.facet_limit.blacklight-format') do
      click_on 'Journal'
    end
    expect(page).to have_no_text('New ideals in business, an account of their practice and their effects upon men and profits')
    expect(page).to have_text('Accounting and business research')
    expect(page).to have_css('.appliedFilter', text: 'Journal')
  end

  scenario 'User can use publication year facets' do
    visit '/catalog'
    fill_in 'q', with: 'business accounting'
    click_button 'search'

    click_on 'Publication Year'
    expect(page).to have_text('Accounting and business research')
    expect(page).to have_text('Disclosure supplement for real estate ventures')
    expect(page).to have_text('The export performance of six manufacturing industries; a comparative study of Denmark, Holland, and Israel')

    within('.facet_limit.blacklight-pub_date') do
      fill_in 'range_pub_date_begin', with: '1950'
      find("input[value='Limit']").click
    end
    expect(page).to have_no_text('New ideals in business, an account of their practice and their effects upon men and profits')
    expect(page).to have_text('Disclosure supplement for real estate ventures')
    expect(page).to have_text('The export performance of six manufacturing industries; a comparative study of Denmark, Holland, and Israel')
    expect(page).to have_css('.appliedFilter', text: '1950')

    within('.facet_limit.blacklight-pub_date') do
      fill_in 'range_pub_date_end', with: '1971'
      find("input[value='Limit']").click
    end

    expect(page).to have_no_text('New ideals in business, an account of their practice and their effects upon men and profits')
    expect(page).to have_no_text('Disclosure supplement for real estate ventures')
    expect(page).to have_text('The export performance of six manufacturing industries; a comparative study of Denmark, Holland, and Israel')
    expect(page).to have_css('.appliedFilter', text: '1950')
    expect(page).to have_css('.appliedFilter', text: '1971')
  end

  scenario 'User can use author facets' do
    visit '/catalog'
    fill_in 'q', with: 'business accounting'
    click_button 'search'

    click_on 'Author'
    expect(page).to have_text('Accounting and business research')
    expect(page).to have_text('The export performance of six manufacturing industries; a comparative study of Denmark, Holland, and Israel')

    within('.facet_limit.blacklight-author_display') do
      click_on 'Hirsch, Seev'
    end
    expect(page).to have_no_text('Accounting and business research')
    expect(page).to have_text('The export performance of six manufacturing industries; a comparative study of Denmark, Holland, and Israel')
    expect(page).to have_css('.appliedFilter', text: 'Hirsch, Seev')
  end

  scenario 'User can use subject facets' do
    visit '/catalog'
    fill_in 'q', with: 'business accounting'
    click_button 'search'

    click_on 'Subject'
    expect(page).to have_text('New ideals in business, an account of their practice and their effects upon men and profits')
    expect(page).to have_text('Accounting and business research')

    within('.blacklight-subject_topic_facet') do
      click_on 'Business, Economy and Management'
    end
    expect(page).to have_no_text('New ideals in business, an account of their practice and their effects upon men and profits')
    expect(page).to have_text('Accounting and business research')
    expect(page).to have_css('.appliedFilter', text: 'Business, Economy and Management')
  end

  scenario 'User can use language facets' do
    visit '/catalog'
    fill_in 'q', with: 'business accounting'
    click_button 'search'

    click_on 'Language'
    expect(page).to have_text('Accounting and business research')
    expect(page).to have_text('De Accountant')

    within('.blacklight-language_facet') do
      click_on 'Dutch'
    end
    expect(page).to have_no_text('Accounting and business research')
    expect(page).to have_text('De Accountant')
    expect(page).to have_css('.appliedFilter', text: 'Dutch')
  end

  scenario 'User can use geographic region facets' do
    visit '/catalog'
    fill_in 'q', with: 'business accounting'
    click_button 'search'

    click_on 'Geographic Region'
    expect(page).to have_text('Accounting and business research')
    expect(page).to have_text('Trade unions under the Combination Acts; five pamphlets, 1799-1823')

    within('.blacklight-subject_geo_facet') do
      click_on 'Great Britain'
    end
    expect(page).to have_no_text('Accounting and business research')
    expect(page).to have_text('Trade unions under the Combination Acts; five pamphlets, 1799-1823')
    expect(page).to have_css('.appliedFilter', text: 'Great Britain')
  end
end
