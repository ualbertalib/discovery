require "rake"

module RakeTasks
  def initialize_rake_tasks
    Rake.application.init
    Rake.application.load_rakefile
  end

  def delete_solr_index
    Rake.application['delete'].invoke
  end

  def ingest_sfx_test_set
    Rake.application['ingest'].invoke('sfx_test_set')
  end

  def ingest_database_test_set
    Rake.application['ingest'].invoke('database_test_set')
  end

  def reenable_task(task)
    Rake.application[task].reenable
  end

  def ingest_all_test_sets
    ingest_sfx_test_set
    reenable_task('ingest')
    ingest_database_test_set
  end
end

