namespace :ingest do
  desc "Import data from SFX"
  task :sfx do
    Rake::Task["fetch"].invoke("http://resolver.library.ualberta.ca/sfx2sirsi/data/sfxdata.xml|sfx.xml")
    ENV['MARC_FILE'] = "#{Rails.root}/data/sfx.xml"
    Rake::Task["solr:marc:index"].invoke
  end
end
