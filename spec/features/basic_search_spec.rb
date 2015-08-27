require_relative "../rake_helper"
require_relative "../spec_helper"

RSpec.feature "Basic Search", :type => :feature do
  scenario "User does a simple search" do
    visit "/results"

    expect(page).to have_text("10032 results for")

    fill_in "q", :with => "accountancy"
    click_button "search"

    expect(page).to have_text("61 results for accountancy")

    fill_in "q", :with => "agricola"
    click_button "search"

    expect(page).to have_text("2 results for agricola")

  end
end

