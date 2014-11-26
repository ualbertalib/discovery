require "json"
require "blacklight/catalog"

class BentoController < ApplicationController
  include Blacklight::Catalog

  def index
    @complete_count = 0

    databases = populate("Catalog", {format: 'Database'})
    @database_count = databases["count"]
    databases.delete("count")
    @databases = databases

    ejournals = populate("Catalog", {source: 'SFX'})
    @ejournals_count = ejournals["count"]
    ejournals.delete("count")
    @ejournals = ejournals

    symphony = populate("Catalog", {source: 'Symphony'})
    @symphony_count = symphony["count"]
    symphony.delete("count")
    @symphony = symphony

    eds = populate("Articles", {})
    @eds_count = eds["count"]
    eds.delete("count")
    @eds = eds
    
  end

  private

  def populate(controller_name, criterion)
    controller = (controller_name+"Controller").constantize
    @query = params[:q]
    documents = {}
    (@solr_response, @document_list) = controller.new.get_search_results(:q => @query, :f => criterion)
    documents["count"] = @solr_response["response"]["numFound"]
    @complete_count += documents["count"]
    @document_list.each do |doc|
      metadata = populate_metadata(doc)
      documents[doc.as_json["id"]] = metadata
    end
    documents
  end

  def populate_metadata(doc)
      metadata = {}
      metadata[:title] = doc.as_json["title_display"]
      metadata[:subtitle] = doc.as_json["subtitle_display"]
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
      metadata
  end
end
