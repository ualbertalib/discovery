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
    fill_in 'q', with: 'Advances in Polymer Science'
    click_button 'search'

    expect(first('#documents .document')).to have_text('Advances in Polymer Science')
    expect(first('#documents .document')).to have_text('Format: Database')
  end
end
