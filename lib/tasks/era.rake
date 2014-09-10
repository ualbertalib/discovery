namespace :ingest do

  desc "Import data from ERA using OAI-PMH"
  task :era do
    Rake::Task["fetch"].invoke("http://era.library.ualberta.ca/oaiprovider/?verb=ListRecords&metadataPrefix=oai_dc|era.xml")
    Rake::Task["ingest:dublin_core"].invoke('data/era.xml|era|file')
  end
end


