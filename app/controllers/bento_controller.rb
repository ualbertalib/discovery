require "json"
require "blacklight/catalog"

class BentoController < ApplicationController
  include Blacklight::Catalog
  include ArticlesHelper
  include ERB::Util

  def index

    load_lookup_tables

    collections = ["databases", "sfx", "symphony", "ebooks", "eds"]
    threads = []

    @rows = 10
    @complete_count = 0

    collections.each do |collection|
      threads << Thread.new do
        self.send("populate_#{collection}")
      end
    end

    threads.each do |thread|
      thread.join
    end

  end

  private

  #desperately needs refactoring

  def populate(controller, facet)
    @query = params[:q]
    documents = {}
    (@solr_response, @document_list) = controller.new.get_search_results(:q => @query, :f => facet)
    documents["count"] = @solr_response["response"]["numFound"]
    @complete_count += documents["count"]
    @document_list.each do |doc|
      metadata = populate_metadata(doc)
      documents[doc.as_json["id"]] = metadata
    end
    documents
  end

  def populate_databases
    databases = populate(CatalogController, {format: 'Database'})
    @database_count = databases["count"]
    databases.delete("count")
    @rows = 5
    @databases = databases
  end

  def populate_sfx
    ejournals = populate(CatalogController, {source: 'SFX'})
    @ejournals_count = ejournals["count"]
    ejournals.delete("count")
    @ejournals = ejournals
  end

  def populate_symphony
    symphony = populate(CatalogController, {source: 'Symphony', electronic_tesim: 'Print'})
    @symphony_count = symphony["count"]
    symphony.delete("count")
    @symphony = symphony

  end

  def populate_ebooks
    ebooks = populate(CatalogController, isource_tesim:'Symphony', format: 'Online'})
    @ebooks_count = ebooks["count"]
    ebooks.delete("count")
    @ebooks = ebooks
  end

  def populate_eds
    if params["q"] then # refactor this
      eds = get_eds_results
      if eds
        @eds_count = eds["count"]
        eds.delete("count")
        @eds = eds
      else
        @eds_count = 0
        @eds = ""
      end
    else
      @eds_count = 0
      @eds = "Empty Search"
    end
  end

  def populate_metadata(doc)
      metadata = {}
      metadata[:title] = parse(doc.as_json["title_display"], doc) if doc.as_json["title_display"]
      metadata[:subtitle] = parse(doc.as_json["subtitle_display"], doc) if doc.as_json["subtitle_display"]
      metadata[:author] = parse(doc.as_json["author_display"], doc, ", ") if doc.as_json["author_display"]
      metadata[:isbn] = doc.as_json["isbn_t"]
      metadata[:issn] = doc.as_json["issn_t"]
      metadata[:year] = doc.as_json["pub_date"]
      metadata[:call_number] = doc.as_json["lc_callnum_display"] # this isn't the correct field. Just a place holder for now
      metadata[:format] = doc.as_json["format"]
      #Symphony: location(s), call number(s), checked out or in: these depend on item
      #record, not bib record.
      #Ejournals: coverage statement
      #Articles: full text?, Link to PDF, Year of publication - not sure
      #these are possible. Depends on EDS API
      metadata
  end

  def parse(field, doc, delimiter=" ")
    parsed_field = ""
    if field.class.name == "String"
      parsed_field = field
    elsif field.class.name == "Array"
      parsed_field = field.join(delimiter)
    end
    parsed_field
  end

  def get_eds_results
    documents = {}
    session[:current_url] = request.original_url
    eds_connect
    params["includefacets"] = "y"
    params["eds_action"] = "addfacetfilter(SourceType:Academic Journals)"
    params["resultsperpage"] = 100
    if has_search_parameters? then
      clean_params = deep_clean(params)
      params = clean_params
      options = generate_api_query(params)
    end

    search(options)

    # refactor
    if session[:results] and session[:results]['SearchResult'] and session[:results]['SearchResult']['Statistics'] and session[:results]['SearchResult']['Statistics']['TotalHits']
      documents["count"] = session[:results]['SearchResult']['Statistics']['TotalHits']
      @complete_count += documents["count"]
    end

    if session[:results] and session[:results]['SearchResult'] and session[:results]['SearchResult'] and session[:results]['SearchResult']['Data'] and session[:results]['SearchResult']['Data']['Records'] then
      results = session[:results]['SearchResult']['Data']['Records']
      results.each do |result|
        metadata = {}
        if has_restricted_access?(result) then
          metadata[:title] = "This result cannot be shown to guests."
        else
          metadata[:title] = show_title(result)
        end
        metadata[:author] = show_authors(result) if has_authors?(result)
        metadata[:url] = result["PLink"]
        metadata[:format] = show_pubtype(result) if has_pubtype?(result)
        metadata[:source] = show_titlesource(result) if has_titlesource?(result)
        documents[result["ResultId"]] = metadata
      end
      documents
    end
  end
end
