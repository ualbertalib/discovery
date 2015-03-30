require "rsolr"
require "rspec-solr"

# The Solr URL we use has to contain full data. Eventually this should
# point to falkirk or forest's index. Currently, the only full data is
# on:
# @solr_url = "http://search.library.ualberta.ca:8983/solr"
# But that's not open, so with an SSH tunnel forwarding ports, I will use:

SOLR_URL = "http://localhost:8983/solr"

def solr_response(field="*", terms, request_handler)
  query_string = "#{field}:#{terms}"
  solr = RSolr.connect(:url => SOLR_URL)
  puts query_string
  solr.get request_handler, :params => {:fq => query_string}
end
