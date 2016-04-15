require_relative "../spec_helper"

RSpec.feature "Basic Search", :type => :feature do
  scenario "User does a simple search" do
    visit "/results"

    expect(page).to have_text("10,024 results for")

    fill_in "q", :with => "accountancy"
    click_button "search"

    expect(page).to have_text("346,831 results for accountancy") # this is actually a bad test, as the numbers can change...

    fill_in "q", :with => "agricola"
    click_button "search"

    expect(page).to have_text("65,869 results for agricola")

  end
end

