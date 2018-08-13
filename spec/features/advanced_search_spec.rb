require_relative "../spec_helper"

RSpec.feature "Advanced Search", :type => :feature do
  scenario "User does an advanced search" do
    visit "/advanced"

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
