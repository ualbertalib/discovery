describe 'ingest rake tasks' do
  before do
    Rake::Task['ingest_info'].reenable
    Rake::Task['ingest'].reenable
  end
  it 'set with environment variable should print to screen and run ingest task successfully' do
    old_env_var = ENV['SOLR_INGEST_URL']
    ENV['SOLR_INGEST_URL'] = Blacklight.connection_config[:url]
    expect { Rake::Task['ingest_info'].invoke }.to output(
      'target is set from environment variable SOLR_INGEST_URL=http://localhost:8983/solr/discovery-test'\
      "\nSolr collection contains 10124 results.\n"
    ).to_stdout
    expect { Rake::Task['ingest'].invoke('symphony_test_set') }.to_not raise_error
    expect { Rake::Task['ingest'].invoke('kule_test') }.to_not raise_error
    ENV['SOLR_INGEST_URL'] = old_env_var
  end
  it 'use url from blacklight config should print to screen and run ingest task successfully' do
    old_env_var = ENV['SOLR_INGEST_URL']
    ENV.delete('SOLR_INGEST_URL')
    expect { Rake::Task['ingest_info'].invoke }.to output(
      "WARNING: Using live target from 'test' stanza in config/blacklight.yml "\
      "(http://localhost:8983/solr/discovery-test)\nSolr collection contains 10124 results.\n"
    ).to_stdout
    expect { Rake::Task['ingest'].invoke('symphony_test_set') }.to_not raise_error
    ENV['SOLR_INGEST_URL'] = old_env_var
  end
  it 'set with environment variable should print to screen and run ingest task successfully' do
    old_env_var = ENV['SOLR_INGEST_URL']
    ENV['SOLR_INGEST_URL'] = Blacklight.connection_config[:url]
    expect { Rake::Task['ingest_info'].invoke }.to output(
      'target is set from environment variable SOLR_INGEST_URL=http://localhost:8983/solr/discovery-test'\
      "\nSolr collection contains 10124 results.\n"
    ).to_stdout
    expect { Rake::Task['ingest'].invoke('kule_test') }.to_not raise_error
    ENV['SOLR_INGEST_URL'] = old_env_var
  end
  it 'use url from blacklight config should print to screen and run ingest task successfully' do
    old_env_var = ENV['SOLR_INGEST_URL']
    ENV.delete('SOLR_INGEST_URL')
    expect { Rake::Task['ingest_info'].invoke }.to output(
      "WARNING: Using live target from 'test' stanza in config/blacklight.yml "\
      "(http://localhost:8983/solr/discovery-test)\nSolr collection contains 10124 results.\n"
    ).to_stdout
    expect { Rake::Task['ingest'].invoke('kule_test') }.to_not raise_error
    ENV['SOLR_INGEST_URL'] = old_env_var
  end
end
