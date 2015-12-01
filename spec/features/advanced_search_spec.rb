require_relative "../rake_helper"
require_relative "../spec_helper"

RSpec.feature "Advanced Search", :type => :feature do
  scenario "User does an advanced search" do
    visit "/advanced"

    fill_in "title", :with => "accountancy"
    click_button "Search"

    expect(page).to have_text("results for accountancy in all library collections")
    expect(page).to have_text("1 - 25 of 51")

  end
end

