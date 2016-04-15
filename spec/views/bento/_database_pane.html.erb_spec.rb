require_relative "../../spec_helper.rb"
require_relative "../../rails_helper"

describe "bento/_database_pane.html.erb", type: :view do
  context "when database results are returned" do
    it "displays database results" do
      assign(:database_count, 10)
      assign(:databases, (1..10).map{|n| {"#{n}" => {title: "Database #{n}"}}}.reduce({}, :merge))
      assign(:local_database_limit, 5)
      render
      expect(rendered).to have_content "10 results"
    end
  end
end
