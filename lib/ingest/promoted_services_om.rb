require_relative "./vocabulary"

class PromotedServicesVocabulary < Vocabulary
  set_terminology do |t|
    t.root(:path => "record")
    t.id(:index_as => :stored_searchable)
    t.title(:index_as => :stored_searchable)
    t.url(:index_as => :stored_searchable)
    t.source(:index_as => :stored_searchable)
    t.format(:index_as => :stored_searchable)
    t.electronic(:index_as => :stored_searchable)
  end
end
