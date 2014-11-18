require "json"

class BentoController < ApplicationController

  def index
    @databases = populate({format: 'Database'})
    @ejournals = populate({source: 'SFX'})
    @symphony = populate({source: 'Symphony'})
  end

  private

  def populate(criterion)
    documents = []
    (@solr_response, @document_list) = CatalogController.new.get_search_results(:q => '', :f => criterion)
    @document_list.each do |db|
      documents << db.as_json["title_display"]
    end
    documents
  end
end
