require "rsolr"
require "logger"

class Ingester
  attr_writer :solr_object

  def initialize
    log_config = YAML.load_file("#{Rails.root}/config/logger.yml")[Rails.env]
    log_dir, log_file = log_config['log_path'].split("/")
    log_dir = "#{Rails.root}/#{log_dir}"
    FileUtils.mkdir_p(log_dir) unless File.directory?(log_dir)
    log_file = File.open(log_dir + "/" + log_file, File::WRONLY | File::APPEND | File::CREAT)
    @ingest_log = Logger.new(log_file)
  end

  def add_document(vocabulary)
    add vocabulary
  end

  def commit
    status = @solr_object.commit
    success = (status["responseHeader"]["status"]).zero? ? "succeeded" : "failed"
    time = status["responseHeader"]["QTime"]
    @ingest_log.info("Solr commit response: Ingest #{success}. Elapsed time #{time} ms.")
  end

  private

  def add(vocabulary)
    status = @solr_object.add vocabulary
    @ingest_log.error("Record ingest failed: Record ID: #{vocabulary['id_tesim'].first}") if status["responseHeader"]["status"] != 0
  end
end
