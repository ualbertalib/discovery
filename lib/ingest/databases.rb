require "csv"
require "logger"
require_relative "./database_om.rb"

class Databases

  attr_reader :xml_records

  def initialize
    @@ingest_log = Logger.new('log/ingest.log')
    @xml_records = []
    database_subjects = JSON.parse(open("http://lgapi.libapps.com/1.1/subjects?site_id=165&key=0d26849c8a09f1da841bc84d4216b8d5").read)
      for subject in database_subjects do
        data = JSON.parse(open("http://lgapi.libapps.com/1.1/assets?site_id=165&key=0d26849c8a09f1da841bc84d4216b8d5&asset_types=10&subject_ids=#{subject['id']}").read)
        for db in data do
          db["subject"] = subject["name"]
          db["type"] = "Database"
          db["electronic"] = "Online"
          db["title"] = db["name"]
          db["more_info"] = db["more-info"]
          db["enable_proxy"] = db["enable-proxy"]
          @xml_records <<  db.to_xml
        end
      end
    @@ingest_log.info("-- Preparing to ingest #{@xml_records.size} records...")
  end

  def xml_file
    output = "<?xml version=\"1.0\"?><root><databases>"
    @xml_records.each do |record|
      db_vocabulary = DatabaseVocabulary.from_xml(record)
      output += db_vocabulary.to_xml.gsub('<?xml version="1.0" encoding="UTF-8"?>', "")
    end
    output += "</databases></root>"
  end

end
