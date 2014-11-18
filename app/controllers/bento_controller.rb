require "json"

class BentoController < ApplicationController

  def index
    databases = populate({format: 'Database'})
    @database_count = databases["count"]
    databases.delete("count")
    @databases = databases

    ejournals = populate({source: 'SFX'})
    @ejournals_count = ejournals["count"]
    ejournals.delete("count")
    @ejournals = ejournals

    symphony = populate({source: 'Symphony'})
    @symphony_count = symphony["count"]
    symphony.delete("count")
    @symphony = symphony
  end

  private

  def populate(criterion)
    documents = {}
    (@solr_response, @document_list) = CatalogController.new.get_search_results(:q => '', :f => criterion)
    documents["count"] = @solr_response["response"]["numFound"]
    @document_list.each do |db|
      documents[db.as_json["id"]] = db.as_json["title_display"]
    end
    documents
  end
end
