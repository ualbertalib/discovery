require 'rsolr'

desc 'Delete all records from solr index'
task :delete, [:records] do |t, args|

  solr = RSolr.connect :url=>"http://localhost:8983/solr"
  # Add collection logic at some point, e.g. "source:Symphony"
  solr.delete_by_query args.records
  solr.commit
end
