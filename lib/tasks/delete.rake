require 'rsolr'

@config_file = YAML.load_file("#{Rails.root}/config/ingest.yml")

desc 'Delete all records from solr index'
task :delete, [:records] do |t, args|
  @c = IngestConfiguration.new("databases", @config_file)
  solr = RSolr.connect :url=>@c.solr
  case args.records

  when "databases"
    solr.delete_by_query 'format:Database'
  when "sfx"
    solr.delete_by_query 'source:SFX'
  when "symphony"
    solr.delete_by_query 'source:Symphony'
  else
    solr.delete_by_query '*:*'
  end

  solr.commit
end
