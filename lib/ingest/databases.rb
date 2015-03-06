require "csv"
require_relative "./database.rb"

class Databases

  attr_reader :xml_records

  def initialize(filename)
    @xml_records = []
    CSV.foreach(filename) do |row|
      next if row.first=="RECORDID"
      db = Database.new
      db.parse(row)
      @xml_records <<  db.to_xml
    end
  end

end
