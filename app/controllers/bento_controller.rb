require "json"
require "blacklight/catalog"

class BentoController < ApplicationController
  include Blacklight::Catalog

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

    eds = get_eds_results
    @eds_count = eds["count"]
    eds.delete("count")
    @eds = eds
    
    @complete_count = @symphony_count + @ejournals_count + @database_count + @eds_count
  end

  private

  def populate(criterion)
    @query = params[:q]
    documents = {}
    (@solr_response, @document_list) = CatalogController.new.get_search_results(:q => @query, :f => criterion)
    documents["count"] = @solr_response["response"]["numFound"]
    @document_list.each do |doc|
      metadata = {}
      metadata[:title] = doc.as_json["title_display"]
      metadata[:author] = doc.as_json["author_display"]
      metadata[:isbn] = doc.as_json["isbn_t"]
      metadata[:issn] = doc.as_json["issn_t"]
      metadata[:year] = doc.as_json["pub_date"]
      metadata[:call_number] = doc.as_json["lc_callnum_display"] # this isn't the correct field. Just a place holder for now
      #Symphony: location(s), call number(s), checked out or in: these depend on item
      #record, not bib record.
      #Ejournals: coverage statement
      #Articles: full text?, Link to PDF, Year of publication - not sure
      #these are possible. Depends on EDS API
      documents[doc.as_json["id"]] = metadata
    end
    documents
  end

  def get_eds_results
    @query = params[:q]
    documents = {}
    (@solr_response, @document_list) = ArticlesController.new.get_search_results(:q => @query) #, :f => {format: 'Serial'})
    documents["count"] = @solr_response["response"]["numFound"]
    @document_list.each do |doc|
      metadata = {}
      metadata[:title] = doc.as_json["title_display"]
      metadata[:subtitle] = doc.as_json["subtitle_display"]
      metadata[:author] = doc.as_json["author_display"].split.first
      metadata[:year] = doc.as_json["pub_date"]
      documents[doc.as_json["id"]] = metadata
     end
    documents
  end
end
