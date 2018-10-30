require_relative "./vocabulary"

class DatabaseVocabulary < Vocabulary
  set_terminology do |t|
    #    t.root(path: "databases")
    t.id(index_as: :stored_searchable)
    t.title(index_as: :stored_searchable)
    t.databasedescription(index_as: :stored_searchable)
    t.url(index_as: :stored_searchable)
    t.moreinfo(index_as: :stored_searchable)
    t.enableproxy(index_as: :stored_searchable)
    t.subject(path: "subject/subject", index_as: :stored_searchable)
    t.type(index_as: :stored_searchable)
    require_relative "./vocabulary"

    class DatabaseVocabulary < Vocabulary
      set_terminology do |t|
        #    t.root(path: "databases")
        t.id(index_as: :stored_searchable)
        t.title(index_as: :stored_searchable)
        t.databasedescription(index_as: :stored_searchable)
        t.url(index_as: :stored_searchable)
        t.moreinfo(index_as: :stored_searchable)
        t.enableproxy(index_as: :stored_searchable)
        t.subject(path: "subject/subject", index_as: :stored_searchable)
        t.type(index_as: :stored_searchable)
        t.electronic(index_as: :stored_searchable)
        t.location(index_as: :stored_searchable)
        t.icons(index_as: :stored_searchable)
        t.languagenote(index_as: :stored_searchable)
      end
    end
    t.electronic(index_as: :stored_searchable)
    t.location(index_as: :stored_searchable)
    t.icons(index_as: :stored_searchable)
    t.languagenote(index_as: :stored_searchable)
  end
end
