require_relative "../rake_helper"
require_relative "../spec_helper"

include RakeTasks

initialize_rake_tasks
delete_solr_index
ingest_sfx_test_set

RSpec.feature "Ejournals page test", :type => :feature do
  scenario "User browses the ejournals page" do
    visit "/ejournals"

    expect(page).to have_text("results for in electronic journals")
    expect(page).to have_text("1 - 14 of 14")

    fill_in "q", :with => "accountancy"
    click_button "search"

    expect(page).to have_text("results for accountancy in electronic journals")
    expect(page).to have_text("1 - 6 of 6")

  end
end

