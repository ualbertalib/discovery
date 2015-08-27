require_relative "./relevance_helper"

describe "Search by title" do
  it "should return only one title" do

    resp = solr_response("title_display", '"Shakespeare at the Globe"', "select")
    docs = resp['response']['docs']
    hits = docs.size
    expect(hits).to eq 1
    expect(docs.first['title_display'].first).to eq "Shakespeare at the Globe"
    expect(docs.first['author_display'].first).to eq "Beckerman, Bernard"
    expect(docs.first['pub_date'].first).to eq "1966"


    # resp = solr_response("title_display", '"The Great Gatsby"', "select")
    # docs = resp['response']['docs']
    # hits = docs.size
    # expect(hits).to eq 5
    # expect(docs.first['author_display'].first).to eq "Fitzgerald, F. Scott (Francis Scott), 1896-1940"
  end
end
