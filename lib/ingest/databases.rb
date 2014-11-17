require_relative "./database.rb"

class Databases

  attr_reader :xml_records

  def initialize(filename)
    @xml_records = []
    File.open(filename).each_line do |line|
      db = Database.new
      db.parse(line)
      @xml_records <<  db.to_xml
    end
  end

end
