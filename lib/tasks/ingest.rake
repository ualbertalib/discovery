require "#{Rails.root}/lib/ingest/batch_ingest.rb"
require "#{Rails.root}/lib/ingest/dublin_core_om.rb"
require "#{Rails.root}/lib/ingest/peel_mods_om.rb"
require "#{Rails.root}/lib/ingest/curriculum_mods_om.rb"

require "yaml"

@config = YAML.load_file("#{Rails.root}/config/ingest.yml")

desc 'ingest records' # add config parameter for directory ingest?
task :ingest, [:name] do |t, args|
  config = @config[args.name]
  Rake::Task["fetch"].invoke("#{config["endpoint"]}|#{config["path"]}") if config["fetch"]

  case config["schema"]
  when "mods", "dublin_core"
    batch_ingester = BatchIngest.new
    batch_ingester.ingester = Ingester.new
    batch_ingester.solr = @config["solr"]
    batch_ingester.root = config["root"]
    batch_ingester.record_delimiter = config["delimiter"]
    batch_ingester.namespace = eval(config["namespace"]) #,  "xmlns:dc" => "http://purl.org/dc/elements/1.1/","xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance" }
    config["mode"]=="file" ? batch_ingester.from_file(config["path"], config["vocabulary"].constantize) : batch_ingester.from_directory(config["path"], config["vocabulary"].constantize)

  when "marc"
    ENV['MARC_FILE'] = config["path"]
    Rake::Task["solr:marc:index"].invoke
  end
end

namespace :ingest do
  desc 'ingest all data sources'
  task :all do
    @config["collections"].each do |collection|
      Rake::Task["ingest"].invoke(collection)
      Rake::Task["ingest"].reenable
    end
  end
end
