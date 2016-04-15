require "json"
require "blacklight/catalog"
require "eds_helper"

class BentoController < ApplicationController
  include Blacklight::Catalog
  include ArticlesHelper
  include ERB::Util
  include EdsHelper

  def index

    load_lookup_tables

    collections = ["databases", "sfx", "symphony", "eds"]
    threads = []

    @complete_count = 0

    @eds_count = 0
    @eds = "Empty Search"

    collections.each do |collection|
      self.send("populate_#{collection}")
    end

  end

  private

  def populate(facet)
    @query = params[:q]
    documents = {}
    (@solr_response, @document_list) = search_results(facet)
    documents["count"] = @solr_response["response"]["numFound"]
    @complete_count += documents["count"]
    @document_list.each do |doc|
      documents[doc.as_json["id"]] = populate_metadata(doc)
    end
    documents
  end

  def search_results(facet)
    self.get_search_results(:q => @query, :f => facet, :rows => 100)
  end

  def populate_collection(options = {})
    collection = populate(options)
    count = collection["count"]
    collection.delete("count")
    return collection, count
  end

  def populate_databases
    @rows = 5
    @databases, @database_count = populate_collection({format: 'Database'})
  end

  def populate_sfx
    @journals, @journals_count = populate_collection({source: 'SFX'})
  end

  def populate_symphony
    @symphony, @symphony_count = populate_collection({source: 'Symphony'})
  end

  def populate_metadata(doc)
      metadata = {}
      metadata[:title] = parse(doc.as_json["title_display"], doc) if doc.as_json["title_display"]
      metadata[:subtitle] = parse(doc.as_json["subtitle_display"], doc) if doc.as_json["subtitle_display"]
      metadata[:edition] = parse(doc.as_json["edition_tesim"], doc) if doc.as_json["edition_tesim"]
      metadata[:author] = parse(doc.as_json["author_display"], doc, ", ") if doc.as_json["author_display"]
      metadata[:isbn] = doc.as_json["isbn_t"]
      metadata[:issn] = doc.as_json["issn_t"]
      metadata[:year] = doc.as_json["pub_date"]
      metadata[:call_number] = doc.as_json["lc_callnum_display"] # this isn't the correct field. Just a place holder for now
      metadata[:format] = doc.as_json["format"]
      metadata[:electronic] = doc.as_json["electronic_tesim"]
      metadata[:source] = doc.as_json["source_tesim"]
      metadata[:locations] = doc.as_json["location_tesim"]
      metadata[:ual] = belongs_to_ual?(doc.as_json["held_by_tesim"].first.split) if doc.as_json["held_by_tesim"]
      metadata
  end

  def belongs_to_ual?(array_of_location_codes)
    array_of_location_codes.any? { |code| @library_codes[code.to_i].include? "University of Alberta" }
  end

  def parse(field, doc, delimiter=" ")
    field.class.name == "String" ? field : field.join(delimiter)
  end

end
