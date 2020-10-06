require 'rails_helper'

RSpec.describe 'Search results have proper metadata', type: :feature do
  scenario 'User can view metadata of a symphony item' do
    visit '/catalog'
    fill_in 'q', with: 'Outlines of the life of Shakespeare'
    click_button 'search'

    expect(first('#documents .document')).to have_text('Outlines of the life of Shakespeare')
    expect(first('#documents .document')).to have_text('Author: Halliwell-Phillipps, J. O. (James Orchard), 1820-1889')
    expect(first('#documents .document')).to have_text('Format: Book')
    expect(first('#documents .document')).to have_text('Publication Year: 1966')
    expect(first('#documents .document')).to have_text('Copies owned by: University of Alberta Rutherford-Humanities & Social Science')
  end

  scenario 'User can view metadata of a database item' do
    visit '/catalog'
    fill_in 'q', with: 'GamingDirectory.com'
    click_button 'search'

    expect(first('#documents .document')).to have_text('GamingDirectory.com')
    expect(first('#documents .document')).to have_text('Format: Database')
    expect(first('#documents .document')).to have_text('Language: English')

    # Ensure conditions of use are displayed.
    expect(first('#documents .document')).to have_link('https://www.library.ualberta.ca/about-us/policies/restricted-resource-info')
    expect(first('#documents .document')).to have_link('https://www.library.ualberta.ca/about-us/policies/conditions-of-use/registration-required')
    expect(first('#documents .document')).to have_link('https://www.library.ualberta.ca/about-us/policies/conditions-of-use/restricted')
  end

  scenario 'User can view metadata of a journal item' do
    visit '/catalog'
    fill_in 'q', with: 'Abacus'
    click_button 'search'

    expect(first('#documents .document')).to have_text('Abacus')
    expect(first('#documents .document')).to have_text('Format: Journal')
    expect(first('#documents .document')).to have_text('Note: This is an Electronic Journal')
  end
end
