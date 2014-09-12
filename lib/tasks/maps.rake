namespace :ingest do
  desc "Import data from from the William Wonders map database"
  task :maps do
    ENV['MARC_FILE'] = "#{Rails.root}/data/maps.xml"
    Rake::Task["solr:marc:index"].invoke
  end
end
