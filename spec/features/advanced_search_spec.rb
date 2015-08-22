require_relative "../rake_helper"
require_relative "../spec_helper"

include RakeTasks

initialize_rake_tasks
delete_solr_index
ingest_all_test_sets

RSpec.feature "Basic Search", :type => :feature do
  scenario "User does a simple search" do
    visit "/advanced"

    fill_in "title", :with => "accountancy"
    click_button "Search"

    expect(page).to have_text("results for accountancy in all library collections")
    expect(page).to have_text("1 - 6 of 6")

  end
end

