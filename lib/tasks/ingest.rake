require "#{Rails.root}/lib/ingest/batch_ingest.rb"
require "#{Rails.root}/lib/ingest/dublin_core_om.rb"
require "#{Rails.root}/lib/ingest/peel_mods_om.rb"
require "#{Rails.root}/lib/ingest/curriculum_mods_om.rb"

namespace :ingest do

  desc 'ingest Dublin Core records'
  # Syntax: rake ingest:dublin_core "data/era.xml|era|file"
  task :dublin_core, [:file] do |t, args|
    path = args.file.split("|").first
    mode = args.file.split("|").last
    batch_ingester = BatchIngest.new
    batch_ingester.ingester = Ingester.new
    batch_ingester.solr = "http://localhost:8983/solr"
    batch_ingester.root = "//xmlns:OAI-PMH"
    batch_ingester.record_delimiter = "//xmlns:record"
    batch_ingester.namespace = {"xmlns" => "http://www.openarchives.org/OAI/2.0/"} #,  "xmlns:dc" => "http://purl.org/dc/elements/1.1/","xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance" }
    mode=="file" ? batch_ingester.from_file(path, DublinCoreVocabulary) : batch_ingester.from_directory(path, DublinCoreVocabulary)
  end
  
  desc 'ingest Peel MODS records'
  # Syntax: rake ingest:peel_mods "data/peel.xml|peel|file"
  task :peel_mods, [:file] do |t, args|
    path = args.file.split("|").first
    mode = args.file.split("|").last
    batch_ingester = BatchIngest.new
    batch_ingester.ingester = Ingester.new
    batch_ingester.solr = "http://localhost:8983/solr"
    batch_ingester.root = "//xmlns:mods"
    batch_ingester.record_delimiter = "//xmlns:mods"
    batch_ingester.namespace = {"xmlns" => "http://www.loc.gov/mods/v3"}
    mode=="file" ? batch_ingester.from_file(path, PeelModsVocabulary) : batch_ingester.from_directory(path, PeelModsVocabulary)
  end
  
  desc 'ingest Curriculum MODS records'
  # Syntax: rake ingest:curriculum_mods "data/curriculum.xml|file"
  task :curriculum_mods, [:file] do |t, args|
    path = args.file.split("|").first
    mode = args.file.split("|").last
    batch_ingester = BatchIngest.new
    batch_ingester.ingester = Ingester.new
    batch_ingester.solr = "http://localhost:8983/solr"
    batch_ingester.root = "//mods:modsCollection"
    batch_ingester.record_delimiter = "//mods:mods"
    batch_ingester.namespace = {"xmlns:mods" => "http://www.loc.gov/mods/v3"}
    mode=="file" ? batch_ingester.from_file(path, CurriculumModsVocabulary) : batch_ingester.from_directory(path, CurriculumModsVocabulary)
  end
end

