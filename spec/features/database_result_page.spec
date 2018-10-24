require_relative "../spec_helper"

RSpec.feature "Database page test", :type => :feature do
  scenario "User browses the database page" do
    visit "/databases"

    expect(page).to have_text("Results for")
    expect(page).to have_text("1 - 10 of 10")

    fill_in "q", :with => "CAB Abstracts"
    click_button "search"

    expect(page).to have_text("Results for CAB Abstracts")
    expect(page).to have_text("1 entry found")

    expect(page).to have_text("Online")
    expect(page).to have_text("Database")
    expect(page).to have_text("Aboriginal Sport & Recreation")
    expect(page).to have_text("Soil Science")
    expect(page).to have_text("Format: Database")
  end
end
