require_relative "./vocabulary"

class DublinCoreVocabulary < Vocabulary

  set_terminology do |t|
    t.root(path: "OAI-PMH", "xmlns:dc" => "http://purl.org/dc/elements/1.1/","xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance")
    t.id(:path=>"setSpec", :index_as => :stored_searchable)
    t.title(:namespace_prefix => "dc", :index_as => :stored_searchable)
    t.creator(:namespace_prefix => "dc", :index_as => :stored_searchable)
    t.subject(:namespace_prefix => "dc", :index_as => :stored_searchable)
    t.description(:namespace_prefix => "dc", :index_as => :stored_searchable)
    t.publisher(:namespace_prefix => "dc", :index_as => :stored_searchable)
    t.contributors(:namespace_prefix => "dc", :index_as => :stored_searchable)
    t.date(:namespace_prefix => "dc", :index_as => :stored_searchable)
    t.type(:namespace_prefix => "dc", :index_as => :stored_searchable)
    t.format(:namespace_prefix => "dc", :index_as => :stored_searchable)
    t.identifier(:namespace_prefix => "dc", :index_as => :stored_searchable)
    t.source(:namespace_prefix => "dc", :index_as => :stored_searchable)
    t.language(:namespace_prefix => "dc", :index_as => :stored_searchable)
    t.relation(:namespace_prefix => "dc", :index_as => :stored_searchable)
    t.coverage(:namespace_prefix => "dc", :index_as => :stored_searchable)
    t.rights(:namespace_prefix => "dc", :index_as => :stored_searchable)
    t.oai_id(:path => "identifier", :index_as => :stored_searchable) #These are OAI specific - have to break them out for other kinds of DC metadata
    t.datestamp(:index_as => :stored_searchable)
    t.spec(:path => "setSpec", :index_as => :stored_searchable)
  end

  def self.xml_template
    Nokogiri.XML.parse('<OAI-PMH xmlns="http://openarchives.org/OAI/2.0/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance/"/>')
  end

end
