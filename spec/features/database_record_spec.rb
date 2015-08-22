require_relative "../rake_helper"
require_relative "../spec_helper"

include RakeTasks

initialize_rake_tasks
delete_solr_index
ingest_database_test_set

RSpec.feature "Database record test", :type => :feature do
  scenario "User browses a database record page" do
    visit "/catalog/61"

    expect(page).to have_text("ABI Inform Complete")
    expect(page).to have_text("Format: E-journal, Database")
    expect(page).to have_text("Coverage")
    expect(page).to have_text("1970 - present")
    expect(page).to have_text("URL")
    expect(page).to have_text("http://library.ualberta.ca/databases/databaseinfo/index.cfm?ID=61")
  
  end
end

