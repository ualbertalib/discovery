module Blacklight::Linking_Utilities
  ############
  # Linking Utilities
  ############

  # pulls <QueryString> from the results of the current search to serve as the baseURL for next request
  def generate_next_url
    if @results.present?
      url = HTMLEntities.new.decode(@results['SearchRequestGet']['QueryString'])
      
      #blacklight expects the search term to be in the parameter 'q'.
      #q is moved back to 'query-1' in 'generate_api_query'
      #should probably pull from Info method to determine replacement strings
      #i could turn the query into a Hash, but available functions to do so delete duplicated params (Addressable)
      url.gsub!("query-1=AND,TI:","q=")
      url.gsub!("query-1=AND,AU:","q=")
      url.gsub!("query-1=AND,SU:","q=")
      url.gsub!("query-1=AND,","q=")
      
      #Rails framework doesn't allow repeated params.  turning these into arrays fixes it.
      url.gsub!("facetfilter=","facetfilter[]=")
      url.gsub!("limiter=","limiter[]=")
      
      #i should probably pull this from the query, not the URL
      if (params[:search_field]).present?
        url << "&search_field=" << params[:search_field].to_s
      end
      return url.gsub("&sort=relevance","") # hack to get rid of buggy sort behaviour. Sam Popowich
    else
      return ''
    end
  end

  # should replace this functionality with AddQuery/RemoveQuery actions
  def generate_next_url_newvar_from_hash(variablehash)
    uri = Addressable::URI.parse(request.fullpath.split("?")[0] + "?" + generate_next_url)
    newUri = uri.query_values.merge variablehash
    uri.query_values = newUri
    return uri.query.to_s
  end

  #for the search form at the top of results
  #retains some of current search's fields (limiters)
  #discards pagenumber, facets and filters, actions, etc.
  def show_hidden_field_tags
    hidden_fields = "";
    params.each do |key, value|
      unless ((key == "search_field") or (key == "fromDetail") or (key == "facetfilter") or (key == "pagenumber") or (key == "q") or (key == "dbid") or (key == "an"))
        if (key == "eds_action")
          if ((value.scan(/addlimiter/).length > 0) or (value.scan(/removelimiter/).length > 0) or (value.scan(/setsort/).length > 0) or (value.scan(/SetResultsPerPage/).length > 0))
            hidden_fields << '<input type="hidden" name="' << key.to_s << '" value="' << value.to_s << '" />'
          end
        elsif value.kind_of?(Array)
          value.each do |arrayVal|
            hidden_fields << '<input type="hidden" name="' << key.to_s << '[]" value="' << arrayVal.to_s << '" />'                
          end
        else
          hidden_fields << '<input type="hidden" name="' << key.to_s << '" value="' << value.to_s << '" />'
        end
      end
    end
    return hidden_fields.html_safe
  end
end
