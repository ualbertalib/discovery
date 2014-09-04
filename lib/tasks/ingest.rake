require "#{Rails.root}/lib/ingest/batch_ingest.rb"
require "#{Rails.root}/lib/ingest/dublin_core_om.rb"

namespace :ingest do

  desc 'ingest Dublin Core records'
  task :dublin_core do |t, args|
    path = ARGV.last.split("|").first
    mode = ARGV.last.split("|").last
    batch_ingester = BatchIngest.new
    batch_ingester.ingester = Ingester.new
    batch_ingester.solr = "http://localhost:8983/solr"
    batch_ingester.root = "//xmlns:record"
    batch_ingester.namespace = {"xmlns" => "http://www.openarchives.org/OAI/2.0/"}
    mode=="file" ? batch_ingester.from_file(path, DublinCoreVocabulary) : batch_ingester.from_dir(path)
    task ARGV.last.to_sym do ; end
  end
end

