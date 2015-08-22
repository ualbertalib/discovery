require_relative "../rake_helper"
require_relative "../spec_helper"

include RakeTasks

initialize_rake_tasks
delete_solr_index
ingest_database_test_set

RSpec.feature "Database page test", :type => :feature do
  scenario "User browses the database page" do
    visit "/databases"

    expect(page).to have_text("results for in databases")
    expect(page).to have_text("1 - 4 of 4")

    fill_in "q", :with => "agricola"
    click_button "search"

    expect(page).to have_text("results for agricola in databases")
    expect(page).to have_text("1 entry found")

  end
end

