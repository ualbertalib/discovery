require_relative "../spec_helper"

RSpec.feature "Ejournals page test", :type => :feature do
  scenario "User browses the ejournals page" do
    visit "/journals"

    expect(page).to have_text("Begin your e-journal search here")

    fill_in "q", :with => "accountancy"
    click_button "search"

    expect(page).to have_text("Results for accountancy in e-Journals")
    expect(page).to have_text("1 - 6 of 6")

  end
end

