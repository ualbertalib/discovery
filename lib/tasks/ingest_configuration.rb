class IngestConfiguration
  attr_accessor :solr, :schema, :root, :delimiter, :namespace, :vocabulary, :endpoint, :mode, :path, :collections, :database_csv

  def initialize(collection, config={})
    @solr = config["solr"]
    @collection = config["collections"]
    config[collection].each{ |k, v| instance_variable_set("@#{k}", v) }
  end

  def vocabulary
    @vocabulary.constantize
  end

end
