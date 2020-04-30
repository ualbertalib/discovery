require 'logger'
require "#{Rails.root}/lib/ingest/batch_ingest.rb"
require "#{Rails.root}/lib/ingest/dublin_core_om.rb"
require "#{Rails.root}/lib/ingest/peel_mods_om.rb"
require "#{Rails.root}/lib/ingest/databases.rb"
require "#{Rails.root}/lib/ingest/database_om.rb"
require "#{Rails.root}/lib/ingest/promoted_services_om.rb"
require_relative './ingest_configuration.rb'

require 'yaml'

import 'lib/tasks/delete.rake'

@config_file = YAML.load_file("#{Rails.root}/config/ingest.yml")

desc 'Shows more info about the ingest task'
task :ingest_info do
  if ENV['SOLR_INGEST_URL']
    Blacklight.connection_config[:url] = ENV['SOLR_INGEST_URL']
    puts "target is set from environment variable SOLR_INGEST_URL=#{ENV['SOLR_INGEST_URL']}"
  else # TODO: consider adding some logic to protect this target
    puts "WARNING: Using live target from '#{Rails.env}' stanza in config/blacklight.yml (#{Blacklight.connection_config[:url]})"
  end
  solr = RSolr.connect url: Blacklight.connection_config[:url]
  response = solr.get 'select', params: { q: '*:*', qt: 'standard' }
  puts "Solr collection contains #{response['response']['numFound']} results."
end

desc 'update Solr Marc maps for location facets from current database state'
task :update_solr_marc_maps do
  sh 'rails g solr_marc_prep'
end

desc 'ingest records' # add config parameter for directory ingest?
task :ingest, [:collection] => [:update_solr_marc_maps] do |_t, args|
  log_config = YAML.load_file("#{Rails.root}/config/logger.yml")[Rails.env]
  log_file = if File.exist? log_config['log_path']
               File.open(log_config['log_path'], File::WRONLY | File::APPEND)
             else
               File.open(log_config['log_path'], File::WRONLY | File::CREAT)
             end

  @ingest_log = Logger.new(log_file)
  @ingest_log.info("--- Starting ingest on #{Time.now} ---")
  @collection = args.collection
  @c = IngestConfiguration.new(args.collection, @config_file)

  Rake::Task['fetch'].invoke("#{@c.endpoint}|#{@c.path}") if @c.endpoint

  @ingest_log.info("Starting #{@c.schema} ingest for #{args.collection}")

  case @c.schema

  when 'mods', 'dublin_core', 'services'
    ingest_mods_or_dublin_core

  when 'marc'
    Rake::Task['delete'].invoke('sfx') if @collection.include? 'sfx'
    ingest_marc

  when 'database'
    Rake::Task['delete'].invoke('databases')
    ingest_databases
  end

  @ingest_log.info("--- Finished ingest on #{Time.now} ---")
end

def ingest_mods_or_dublin_core
  batch_ingester = BatchIngest.new
  configure batch_ingester
  run batch_ingester
end

def run(batch_ingester)
  method = "from_#{@c.mode}".to_sym
  if @c.expand_path
    batch_ingester.send method, @c.expand_path, @c.vocabulary
  else
    batch_ingester.send method, @c.path, @c.vocabulary
  end
end

def configure(batch_ingester)
  batch_ingester.ingester = Ingester.new
  batch_ingester.solr = @c.solr
  batch_ingester.root = @c.root
  batch_ingester.record_delimiter = @c.delimiter
  batch_ingester.namespace = eval(@c.namespace)
end

def ingest_marc
  ENV['MARC_FILE'] = @c.path
  ENV['CONFIG_PATH'] = @c.config
  Rake::Task['solr:marc:index'].invoke
end

def ingest_databases
  unless @c.test
    db = Databases.new
    File.open(@c.expand_path, 'w') do |f|
      f.write db.xml_file
    end
  end
  batch_ingester = BatchIngest.new
  configure batch_ingester
  run batch_ingester
end

namespace :ingest do
  desc 'ingest all data sources'
  task :all do
    @config_file['collections'].each do |collection|
      Rake::Task['ingest'].invoke(collection)
      Rake::Task['ingest'].reenable
    end
  end
end
