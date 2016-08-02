module EdsHelper

  def populate_eds
    if params["q"] then # refactor this
      catch(:eds_connection_error) do
        eds = get_eds_results
        if eds
          @eds_count = eds["count"]
          eds.delete("count")
          @eds = eds
        end
      end
      else
        @eds_count = 0
        @eds = "Empty Search"
    end
  end

  def get_eds_results
    documents = {}
    @current_url = request.original_url
    eds_connect
    params["q"] = params["q"].downcase.gsub("l'", "").gsub("d'", "")
    params["includefacets"] = "y"
    #params["eds_action"] = "addfacetfilter(SourceType:Academic Journals)"
    params["searchmode"]="all"
    params["view"]="brief"
    params["pagenumber"]=1
    params["highlight"]="y"
    params["resultsperpage"] = 100
    if has_search_parameters? then
      clean_params = deep_clean(params)
      params = clean_params
      options = generate_api_query(params)
    end

    search(options)

    # refactor
    if @results and @results['SearchResult'] and @results['SearchResult']['Statistics'] and @results['SearchResult']['Statistics']['TotalHits']
      documents["count"] = @results['SearchResult']['Statistics']['TotalHits']
      @complete_count += documents["count"]
    end

    if @results and @results['SearchResult'] and @results['SearchResult'] and @results['SearchResult']['Data'] and @results['SearchResult']['Data']['Records'] then
      results = @results['SearchResult']['Data']['Records']
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
