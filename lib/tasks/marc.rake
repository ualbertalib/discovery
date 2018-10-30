namespace :ingest do
  desc 'Import marc records from flat file with default config'
  task :marc_from_file do
    puts ARGV.last
    ENV['MARC_FILE'] = ARGV.last
    Rake::Task['solr:marc:index'].invoke
  end
end
