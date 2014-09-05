namespace :ingest do

  desc "Import data from ERA using OAI-PMH"
  task :era do
<<<<<<< HEAD
    Rake::Task["fetch"].invoke("http://era.library.ualberta.ca/oaiprovider/?verb=ListRecords&metadataPrefix=oai_dc|era.xml")
=======
    Rake::Task["fetch"].invoke('http://era.library.ualberta.ca/oaiprovider/?verb=ListRecords&metadataPrefix=oai_dc|era.xml')
>>>>>>> 337c9f4d8583be2a1978eb95083d42c617a18845
    Rake::Task["ingest:dublin_core"].invoke('data/era.xml|file')
  end
end


