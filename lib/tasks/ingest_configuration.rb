class IngestConfiguration
  attr_accessor :solr, :schema, :root, :delimiter, :namespace, :vocabulary, :endpoint, :mode, :path, :collections, :database_csv, :config, :proxy, :expand_path, :test

  def initialize(collection, config={})
    if ENV['SOLR_INGEST_URL']
      Blacklight.connection_config[:url] = ENV['SOLR_INGEST_URL']
      Blacklight.connection_config[:writable] = true
    end  
    @proxy = config["proxy"]
    @collection = config["collections"]
    config[collection].each{ |k, v| instance_variable_set("@#{k}", v) }
  end

  def vocabulary
    @vocabulary.constantize
  end

end
