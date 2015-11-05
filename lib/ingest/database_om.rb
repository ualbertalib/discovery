require_relative "./vocabulary"

class DatabaseVocabulary < Vocabulary
  set_terminology do |t|
#    t.root(path: "databases")
    t.id(index_as: :stored_searchable)
    t.title(index_as: :stored_searchable)
    t.description(index_as: :stored_searchable)
    t.url(index_as: :stored_searchable)
    t.moreinfo(index_as: :stored_searchable)
    t.enableproxy(index_as: :stored_searchable)
    t.subject(index_as: :stored_searchable)
    t.type(index_as: :stored_searchable)
    t.electronic(index_as: :stored_searchable)
  end
end
