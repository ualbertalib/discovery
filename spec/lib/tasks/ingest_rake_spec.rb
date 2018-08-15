describe "ingest rake tasks" do
  before do
    Rake::Task['ingest_info'].reenable
    Rake::Task['ingest'].reenable
  end
  it 'set with environment variable should print to screen and run ingest task successfully' do
    old_env_var = ENV['SOLR_INGEST_URL']
    ENV['SOLR_INGEST_URL'] = Blacklight.connection_config[:url]
    expect { Rake::Task["ingest_info"].invoke }.to output("target is set from environment variable SOLR_INGEST_URL=http://localhost:8983/solr/discovery-test\nwritable\nSolr collection contains 10024 results.\n").to_stdout
    expect { Rake::Task['ingest'].invoke('symphony_test_set') }.to_not raise_error SystemExit
    ENV['SOLR_INGEST_URL'] = old_env_var
  end
  it 'set from blacklight config should print to screen and run ingest task successfully' do
    old_env_var = ENV['SOLR_INGEST_URL']
    ENV.delete('SOLR_INGEST_URL')
    expect { Rake::Task["ingest_info"].invoke }.to output("target is set from config/blacklight.yml http://localhost:8983/solr/discovery-test\nwritable\nSolr collection contains 10024 results.\n").to_stdout
    expect { Rake::Task['ingest'].invoke('symphony_test_set') }.to_not raise_error SystemExit
    ENV['SOLR_INGEST_URL'] = old_env_var
  end
  it 'set from blacklight config but not writeable should print to screen and not run ingest task' do
    old_env_var = ENV['SOLR_INGEST_URL']
    ENV.delete('SOLR_INGEST_URL')
    old_writable_flag = Blacklight.connection_config[:writable]
    Blacklight.connection_config[:writable] = nil
    expect { Rake::Task["ingest_info"].invoke }.to output("target is set from config/blacklight.yml http://localhost:8983/solr/discovery-test\nnot writable\nSolr collection contains 10024 results.\n").to_stdout
    expect { Rake::Task['ingest'].invoke('symphony_test_set') }.to raise_error(SystemExit) do |error|
      expect(error.status).to eq(1)
      expect(error.message).to eq 'Target (http://localhost:8983/solr/discovery-test) is read-only'
    end
    Blacklight.connection_config[:writable] = old_writable_flag
    ENV['SOLR_INGEST_URL'] = old_env_var
  end
end
