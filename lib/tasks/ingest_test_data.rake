require_relative "./ingest_test_data_helper"

include RakeTasks

desc 'ingest test data'

task :ingest_test_data do
  delete_solr_index
  ingest_all_test_sets
end

