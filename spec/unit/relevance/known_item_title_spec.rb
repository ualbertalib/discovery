require_relative "./relevance_helper"

describe "Search by title" do
  it "should return only one title" do

    # in this case, there are two editions (2011 and 2012)
    resp = solr_response("title_display", '"Clojure programming"', "select")
    docs = resp['response']['docs']
    hits = docs.size
    expect(hits).to eq 2
    expect(docs.first['title_display'].first).to eq "Clojure programming"
    expect(docs.last['title_display'].first).to eq "Clojure programming"
    expect(docs.first['author_display'].first).to eq "Emerick, Chas"
    expect(docs.last['author_display'].first).to eq "Emerick, Chas"
    expect(docs.first['pub_date'].first).to eq "2011"
    expect(docs.last['pub_date'].first).to eq "2012"


    # resp = solr_response("title_display", '"The Great Gatsby"', "select")
    # docs = resp['response']['docs']
    # hits = docs.size
    # expect(hits).to eq 5
    # expect(docs.first['author_display'].first).to eq "Fitzgerald, F. Scott (Francis Scott), 1896-1940"
  end
end
