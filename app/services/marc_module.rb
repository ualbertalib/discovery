require "nokogiri"

module MarcModule

  def nokogiri(document)
    Nokogiri::XML(document['marc_display']).remove_namespaces!
  end

  def marc_field(document, tag)
    document.xpath("//datafield[@tag='#{tag}']")
  end

  def get_marc_subfield(document, tag)
    document.xpath("subfield[@code='#{tag}']").text
  end
end
