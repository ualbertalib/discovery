require_relative "../rake_helper"
require_relative "../spec_helper"

RSpec.feature "Search history test", :type => :feature do
  scenario "User wants to see their search history" do
    visit "/search_history"
    if page.to_s.include? "Your recent searches"
      click_button "Clear Search History"
    end
    expect(page).to have_text "You have no search history"
    visit "/catalog"
    fill_in "q", :with => "accountancy"
    click_button "search"
    visit "/search_history"
    expect(page).to have_text("Search History")
    expect(page).to have_text("Keyword:accountancy")
  end
end

