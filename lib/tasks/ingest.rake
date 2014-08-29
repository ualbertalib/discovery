namespace :ingest do

  desc 'ingest Dublin Core records'
  task :dublin_core do |t, args|
    require "#{Rails.root}/lib/ingest/batch_ingest.rb"
    path= args[:path]
    mode = args[:mode]
    batch_ingester = BatchIngest.new
    batch_ingester.ingester = Ingester.new
    batch_ingester.root = "//xmlns:record"
    batch_ingester.namespace = {"xmlns" => "http://www.openarchives.org/OAI/2.0/"}
    mode=="file" ? batch_ingester.from_file(path) : batch_ingester.from_dir(path)
  end
end

