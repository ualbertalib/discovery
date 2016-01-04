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
    # can't use Rake.application object because MARC collections can't
    # be run in sequence in the same session.
    `rake ingest[sfx_test_set]`
  end

  def ingest_database_test_set
    args = {:collection => "database_test_set"}
    Rake.application['ingest'].execute(Rake::TaskArguments.new(args.keys, args.values))
  end

  def ingest_symphony_test_set
    `rake ingest[symphony_test_set]`
  end

  def ingest_all_test_sets
    ingest_symphony_test_set
    ingest_sfx_test_set
    ingest_database_test_set
  end
end

