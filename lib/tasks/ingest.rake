require "#{Rails.root}/lib/ingest/batch_ingest.rb"
require "#{Rails.root}/lib/ingest/dublin_core_om.rb"
require "#{Rails.root}/lib/ingest/peel_mods_om.rb"
require "#{Rails.root}/lib/ingest/databases.rb"
require "#{Rails.root}/lib/ingest/database_om.rb"
require_relative "./ingest_configuration.rb"

require "yaml"

@config_file = YAML.load_file("#{Rails.root}/config/ingest.yml")

desc 'ingest records' # add config parameter for directory ingest?
task :ingest, [:collection] do |t, args|
  @c = IngestConfiguration.new(args.collection, @config_file)

  Rake::Task["fetch"].invoke("#{@c.endpoint}|#{@c.path}") if @c.endpoint

  case @c.schema

  when "mods", "dublin_core"
    ingest_mods_or_dublin_core

  when "marc"
    ingest_marc

  when "database"
    ingest_databases
  end

end

def ingest_mods_or_dublin_core
  batch_ingester = BatchIngest.new(solr_url: @c.solr)
  configure batch_ingester
  run batch_ingester
end

def run batch_ingester
  method = "from_#{@c.mode}".to_sym
  if @c.expand_path
    batch_ingester.send method, @c.expand_path, @c.vocabulary
  else
    batch_ingester.send method, @c.path, @c.vocabulary
  end
end

def configure batch_ingester
  batch_ingester.ingester = Ingester.new
  batch_ingester.solr = @c.solr
  batch_ingester.root = @c.root
  batch_ingester.record_delimiter = @c.delimiter
  batch_ingester.namespace = eval(@c.namespace)
end

def ingest_marc
  puts @c.path
  puts @c.config
  ENV['MARC_FILE'] = @c.path
  ENV['CONFIG_PATH'] = @c.config
  Rake::Task["solr:marc:index"].invoke
end

def ingest_databases
    db = Databases.new(@c.path)
    File.open(@c.expand_path, "w"){ |f|
      f.write db.xml_file
    }
    batch_ingester = BatchIngest.new(solr_url: @c.solr)
    configure batch_ingester
    run batch_ingester
end

namespace :ingest do
  desc 'ingest all data sources'
  task :all do
    @config_file["collections"].each do |collection|
      Rake::Task["ingest"].invoke(collection)
      Rake::Task["ingest"].reenable
    end
  end
end
