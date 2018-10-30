require_relative '../spec_helper'

RSpec.feature 'Database record test', type: :feature do
  scenario 'User browses a database record page' do
    visit '/catalog/11710064'

    expect(page).to have_text('Advances in Polymer Science')
    expect(page).to have_text('Format: Database')
    expect(page).to have_text("Fulltext of electronically published titles from Springer's Advances in Polymer Science series.")
    expect(page).to have_text('Subjects')
    expect(page).to have_text('Aboriginal Sport & Recreation')
    expect(page).to have_text('Physics')
    # expect(page).to have_text("Click Here for Access") # now handled by javascript
    # expect(page).to have_text("http://springerlink.metapress.com/link.asp?id=104935") # now handled by javascript
  end
end
