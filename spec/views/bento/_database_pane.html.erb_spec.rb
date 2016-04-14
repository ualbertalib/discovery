require_relative "../../spec_helper.rb"
require_relative "../../rails_helper"

describe "bento/_database_pane.html.erb", type: :view do
  context "when database results are returned" do
    it "displays database results" do
      assign(:database_count, 10)
      assign(:databases, {"1" =>{title: "Database1"},
                          "2" =>{title: "Database2"},
                          "3" =>{title: "Database3"},
                          "4" =>{title: "Database4"},
                          "5" =>{title: "Database5"},
                          "6" =>{title: "Database6"},
                          "7" =>{title: "Database7"},
                          "8" =>{title: "Database8"},
                          "9" =>{title: "Database9"},
                          "10" =>{title: "Database10"}})
      assign(:local_database_limit, 5)
      render
      expect(rendered).to have_content "10 results"
    end
  end
end
