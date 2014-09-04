require 'rsolr'

solr = RSolr.connect :url=>"http://localhost:8983/solr"

if ARGV[0]=="all" then
  solr.delete_by_query "*:*"
  solr.commit
else
  puts "Usage: ruby delete.rb all #delete all"
end
