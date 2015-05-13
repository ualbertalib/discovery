require 'rsolr'

@config_file = YAML.load_file("#{Rails.root}/config/ingest.yml")

desc 'Delete all records from solr index'
task :delete, [:records] do |t, args|
  @c = IngestConfiguration.new("databases", @config_file)
  puts @c
  solr = RSolr.connect :url=>@c.solr
  # Add collection logic at some point, e.g. "source:Symphony"
  solr.delete_by_query args.records
  solr.commit
end
