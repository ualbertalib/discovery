require_relative "./relevance_helper"

describe "Search by ID" do
  it "should return only one result" do
    resp = solr_response("id", "1000953", "select")
    docs = resp['response']['docs']
    hits = docs.size
    expect(hits).to eq 1
    expect(docs.first['title_display'].first).to eq "Chemical and chemical products industries"

    resp = solr_response("id", "1002740", "select")
    docs = resp['response']['docs']
    hits = docs.size
    expect(hits).to eq 1
    expect(docs.first['title_display'].first).to eq "And here the world ends"
  end
end
