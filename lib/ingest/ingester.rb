require "rsolr"
require "logger"

class Ingester
  attr_writer :solr_object

  def initialize
    # log_config = YAML.load_file("#{Rails.root}/config/logger.yml")
    # log_file = File.open(log_config['log_path'], File::WRONLY|File::APPEND)
    # @@ingest_log = Logger.new(log_file)
  end

  def add_document(vocabulary)
    add vocabulary
  end

  def commit
    status = @solr_object.commit
    success = status["responseHeader"]["status"] == 0 ? "succeeded" : "failed"
    time = status["responseHeader"]["QTime"]
    @@ingest_log.info("Solr commit response: Ingest #{success}. Elapsed time #{time} ms.")
  end

private

  def add(vocabulary)
    status = @solr_object.add vocabulary
    @@ingest_log.error("Record ingest failed: Record ID: #{vocabulary["id_tesim"].first}") if status["responseHeader"]["status"] != 0
  end

end
