require "json"
require "open-uri"
require_relative "../spec_helper"

RSpec.feature "Solr Running", :type => :feature do
  scenario "Check if solr is running locally" do
    #visit "http://localhost:8983/solr/blacklight-core/select?wt=json&indent=true"
    response = open("http://localhost:8983/solr/blacklight-core/select?wt=json&indent=true").read
    expect(JSON.parse(response)).to be_a Hash
  end
end
