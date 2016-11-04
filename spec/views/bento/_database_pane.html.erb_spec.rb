require_relative "../../spec_helper.rb"
require_relative "../../rails_helper"

describe "bento/_database_pane.html.erb", type: :view do

  before(:all) do
      assign(:database_count, 10)
      assign(:databases, (1..10).map{|n| {"#{n}" => {title: "Database #{n}"}}}.reduce({}, :merge))
      assign(:local_database_limit, 10)
  end

  context "when database results are returned" do
    it "displays database results" do
      render
      expect(rendered).to have_content "10 results"
    end

    it "should have 10 databases" do
      db_strings = (1..10).map{|n| "#{n}. Database #{n} "}.join " "
      render
      expect(rendered).to have_content db_strings
    end

    it "should display the title for each database" do
      render
      expect(rendered).to have_link("Database 1")
    end

    it "should link to the correct database record" do
      render
      expect(rendered).to have_link("Database 1", :href=>"catalog/1")
    end

    it "should link to the full result set" do
      render
      expect(rendered).to have_link("View all databases")
    end

    it "should display the UAL shield" do
      render
      expect(rendered).to have_css("img[title='licensed for U of A']")
    end
  end
end
