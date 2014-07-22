require "sanitize"
require_relative "../lib/field_set.rb"

#filename = ARGV[0]
root_element = ARGV.last || ""

ARGV.pop

ARGV.each do |filename|
  field_set = FieldSet.new(root_element)
  records = File.open(filename).read
  field_set.add records.gsub("&lt;i&gt;", "").gsub("&lt;/i&gt;", "")

  file_handle = filename.split("/").last.split(".").first
  File.open("data/#{file_handle}_solr.xml", "w"){|f|
    f.puts field_set.to_solr
  }
end


