require "nokogiri"
require 'yaml'

class Database

  attr_accessor :id, :name, :url, :more_info, :enable_proxy, :subject_id, :subject

  def to_xml
    builder = Nokogiri::XML::Builder.new do |xml|
          xml.database {
            xml.id_ record_hash[:id]
            xml.name record_hash[:name]
            xml.url record_hash[:url]
            xml.more_info record_hash[:more_info]
            xml.enable_proxy record_hash[:enable_proxy]
            xml.subject_id record_hash[:subject_id]
            xml.subject record_hash[:subject_name]
            xml.type "Database"
            xml.electronic "Online"
          }
    end
    builder.doc.to_xml(:save_with => Nokogiri::XML::Node::SaveOptions::AS_XML | Nokogiri::XML::Node::SaveOptions::NO_DECLARATION).gsub("\n", "").gsub('""', '"').gsub("&eacute;", "é")

  end

end
