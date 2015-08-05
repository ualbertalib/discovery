require "csv"
require "logger"
require_relative "./database.rb"
require_relative "./database_om.rb"

class Databases

  attr_reader :xml_records

  def initialize(filename)
    @@ingest_log = Logger.new('log/ingest.log')
    @xml_records = []
    database_subjects = YAML.load_file("#{Rails.root}/config/database_subjects.yml")
    CSV.foreach(filename) do |row|
      next if row.first=="RECORDID"
      db = Database.new
      db.parse(row)
      @xml_records <<  db.to_xml(database_subjects)
    end
    @@ingest_log.info("-- Preparing to ingest #{@xml_records.size} records...")
  end

  def xml_file
    output = "<?xml version=\"1.0\"?><root><databases>"
    @xml_records.each do |record|
      db_vocabulary = DatabaseVocabulary.from_xml(record)
      output += db_vocabulary.to_xml.gsub('<?xml version="1.0"?>', "")

    end
    output += "</databases></root>"
    output
  end

end
