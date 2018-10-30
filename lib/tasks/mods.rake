namespace :ingest do
  desc 'ingest MODS records'
  # Syntax: rake ingest:peel["data/peel.xm|file"]
  # Replace root, record_delimiter, namespace, and vocabulary as necessary
  task :mods_from_file, [:file] do |_t, args|
    path = args.file.split("|").first
    mode = args.file.split("|").last
    batch_ingester = BatchIngest.new
    batch_ingester.ingester = Ingester.new
    batch_ingester.solr = "http://localhost:8983/solr" # don't use hard-coded solr. Replace with config/ingest.yml value
    batch_ingester.root = "//xmlns:mods"
    batch_ingester.record_delimiter = "//xmlns:mods"
    batch_ingester.namespace = { "xmlns" => "http://www.loc.gov/mods/v3" }
    mode == "file" ? batch_ingester.from_file(path, PeelModsVocabulary) : batch_ingester.from_directory(path, PeelModsVocabulary)
  end
end
