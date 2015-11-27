require "csv"
require "logger"
require_relative "./database_om.rb"

class Databases

  attr_reader :xml_records

  def initialize
    @@ingest_log = Logger.new('log/ingest.log')
    @xml_records = {}
    database_subjects = JSON.parse(open("http://lgapi.libapps.com/1.1/subjects?site_id=165&key=0d26849c8a09f1da841bc84d4216b8d5").read)
      for subject in database_subjects do
        data = JSON.parse(open("http://lgapi.libapps.com/1.1/assets?site_id=165&key=0d26849c8a09f1da841bc84d4216b8d5&asset_types=10&subject_ids=#{subject['id']}").read)
        for db in data do
          db["subject"] = []
          db["subject"] << subject["name"]
          db["type"] = "Database"
          db["electronic"] = "Online"
          db["title"] = db["name"]
          db["moreinfo"] = db["meta"]["more_info"]
          db["enableproxy"] = db["meta"]["enable_proxy"]
          if @xml_records[db['id']]
            @xml_records[db['id']]['subject'].concat db['subject']
            @xml_records[db['id']].merge db
          else
            @xml_records[db['id']] = db
          end
        end
      end
    @@ingest_log.info("-- Preparing to ingest #{@xml_records.size} records...")
  end

  def xml_file
    output = "<?xml version=\"1.0\"?><root><databases>"
    @xml_records.each do |key,record|
      db_vocabulary = DatabaseVocabulary.from_xml(record.to_xml)
      output += db_vocabulary.to_xml.gsub('<?xml version="1.0" encoding="UTF-8"?>', "")
    end
    output += "</databases></root>"
  end

end
