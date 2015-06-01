require_relative "./relevance_helper"

describe "Search by ID" do
  it "should return only one result" do
    resp = solr_response("id", "5843133", "select")
    docs = resp['response']['docs']
    hits = docs.size
    expect(hits).to eq 1
    expect(docs.first['title_display'].first).to eq "Clojure programming"

    resp = solr_response("id", "5077584", "select")
    docs = resp['response']['docs']
    hits = docs.size
    expect(hits).to eq 1
    expect(docs.first['title_display'].first).to eq "Global warming"
  end
end
