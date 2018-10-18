require_relative "../spec_helper"

RSpec.feature "Advanced Search", :type => :feature do
  scenario "User does an advanced search" do
    visit "/advanced"

    # issue:1178 Library locations should be sorted in alpha order
    # previously these were stored as codes (ie uaeduc, uabusiness) in the index and then
    # mapped to their full title (ie University of Alberta HT Coutts Education, University of Alberta Winspear Business)
    click_link 'Library'
    within '#facet-location_tesim' do
      libraries = all('li span.facet-label').map(&:text)
      expect(libraries.sort).to eq(libraries)
    end

    fill_in "title", :with => "accountancy"
    click_button "Search"

    expect(page).to have_text("Results for accountancy")
    expect(page).to have_text("1 - 25 of 51")

    # for some reason fields other than title don't seem to work
    # (Capybara::ElementNotFound)
    # fill_in "all_fields", :with => "accountancy"
    # click_button "Search"
    #
    # expect(page).to have_text("1 - 25 of 64")

  end
end
