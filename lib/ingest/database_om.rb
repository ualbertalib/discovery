require_relative "./vocabulary"

class DatabaseVocabulary < Vocabulary
  set_terminology do |t|
#    t.root(path: "databases")
    t.id(index_as: :stored_searchable)
    t.name(index_as: :stored_searchable)
    t.url(index_as: :stored_searchable)
    t.more_info(index_as: :stored_searchable)
    t.enable_proxy(index_as: :stored_searchable)
    t.subject_id(index_as: :stored_searchable)
    t.subject_name(index_as: :stored_searchable)
    t.type(index_as: :stored_searchable)
    t.electronic(index_as: :stored_searchable)
  end
end
