require 'rsolr'

desc 'Delete all records from solr index'
task :delete do

  solr = RSolr.connect :url=>"http://localhost:8983/solr"
  # Add collection logic at some point, e.g. "source:Symphony"
  solr.delete_by_query "*:*"
  solr.commit
end
