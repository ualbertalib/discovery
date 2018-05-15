# frozen_string_literal: true

require 'rsolr'

@config_file = YAML.load_file("#{Rails.root}/config/ingest.yml")

desc 'Delete all records from solr index'
task :delete, [:records] do |_t, args|
  c = IngestConfiguration.new(args.records || 'databases', @config_file)
  solr = RSolr.connect url: c.solr
  case args.records

  when 'databases'
    solr.delete_by_query 'format:Database'
  when 'sfx'
    puts 'Deleting SFX'
    solr.delete_by_query 'source:SFX'
  when 'symphony'
    puts 'Deleting Symphony'
    solr.delete_by_query 'source:Symphony'
  else
    solr.delete_by_query '*:*'
  end

  solr.commit
end
