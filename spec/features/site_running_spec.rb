require "json"
require "open-uri"
require_relative "../spec_helper"

RSpec.feature "Site Running", :type => :feature do
  scenario "Check if site is is running locally" do
    response = open("http://localhost:3000/results")
    expect(response.status).to eq ["200", "OK "]
  end
end
