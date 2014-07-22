# -*- encoding : utf-8 -*-

module Blacklight::ArticlesHelperBehavior

  ############
  # Utility functions and libraries
  ############
  
  require 'fileutils' # for interacting with files
  require "addressable/uri" # for manipulating URLs in the interface
  require "htmlentities" # for deconding/encoding URLs
  require "cgi"
  require 'open-uri'
  
  def html_unescape(text)
    return CGI.unescape(text)
  end

  def processAPItags(apiString)
    processed = HTMLEntities.new.decode apiString
    return processed.html_safe
  end

  ###########
  # API Interaction
  ###########

  def eds_connect
    @debug_notes = ""

    @connection = EDSApi::ConnectionHandler.new(2)
    File.open(auth_file_location,"r") {|f|
        @api_userid = f.readline.strip
        @api_password = f.readline.strip
        @api_profile = f.readline.strip
    }
    @connection.uid_init(@api_userid, @api_password, @api_profile)

    if has_valid_auth_token?
      @auth_token = getAuthToken
    else
      @debug_notes << "<p>New Authentication Token Generated in eds_connect</p>"
      @connection.uid_authenticate(:json)
      @auth_token = @connection.show_auth_token
      writeAuthToken(@auth_token)
    end
    
    if session[:session_key].present?
      if session[:session_key].include?('Error')
        @session_key = @connection.create_session(@auth_token)
        session[:session_key] = @session_key
        #return "Session key made: " + session_key.to_s
        @debug_notes << "<p>New Session Key Generated (error message in existing session key)</p>"
      else 
        @session_key = session[:session_key]
        #return "Reusing session key: " + session_key
        #@debug_notes << "Found existing session key in eds_connect..."  << @session_key << "..."
      end
    else
      @session_key = @connection.create_session(@auth_token)
      session[:session_key] = @session_key
      #return "Session key made: " + session_key.to_s
      #@debug_notes << "Did not find existing session key in eds_connect...new token: " << @session_key << "..."
      @debug_notes << "<p>New Session Key Generated (no session key found)</p>"
    end
    
  end

  # after basic functions like SEARCH, INFO, and RETRIEVE, check to make sure a new session token wasn't generated
  # if it was, use the new session key from here on out
  def checkSessionCurrency
    currentSessionKey = @connection.show_session_token
    #@debug_notes << "<p>Comparing...</p><p>" << currentSessionKey << "<br />" << get_session_key << "</p>"
    if currentSessionKey != get_session_key
      session[:session_key] = currentSessionKey
      @debug_notes << "<p>An API call to SEARCH, INFO, or RETRIEVE generated a new session token</p>"
    end
  end


  #generates parameters for the API call given URL parameters
  def generate_api_query(options)

    #removing Rails and Blacklight parameters
    options.delete("action")
    options.delete("controller")
    options.delete("utf8")

    #translate Blacklight search_field into query index
    if params["search_field"].present?
      if params["search_field"] == "author"
        fieldcode = "AU:"
      elsif params["search_field"] == "subject"
        fieldcode = "SU:"
      elsif params["search_field"] == "title"
        fieldcode = "TI:"
      else
        fieldcode = ""
      end
    else
      fieldcode = ""
    end
    
    #should write something to allow this to be overridden
    searchmode = "AND"
    
    #build 'query-1' API URL parameter
    searchquery_extras = searchmode + "," + fieldcode
    
    #filter to make sure the only parameters put into the API query are those that are expected by the API
    edsKeys = ["eds_action","q","query-1","facetfilter[]","facetfilter","sort","includefacets","searchmode","view","resultsperpage","sort","pagenumber","highlight", "limiter", "limiter[]"]
    edsSubset  = {}
    options.each do |key,value|
      if edsKeys.include?(key)
        edsSubset[key] = value
      end
    end
    
    #rename parameters to expected names
    #action and query-1 were renamed due to Rails and Blacklight conventions respectively
    mappings = {"eds_action" => "action", "q" => "query-1"}
    newoptions = Hash[edsSubset.map {|k, v| [mappings[k] || k, v] }]
    
    #repace the raw query, adding searchmode and fieldcode
    changeQuery = newoptions["query-1"]
    uri = Addressable::URI.new
    uri.query_values = newoptions
    searchquery = uri.query
    searchtermindex = searchquery.index('query-1=') + 8
    searchquery.insert searchtermindex, searchquery_extras
    
    # , : ( ) - unencoding expected punctuation
    searchquery = searchquery.gsub('%28','(').gsub('%3A',':').gsub('%29',')').gsub('%23',',')
    #@debug_notes << "<p>" << searchquery.to_s << "</p>"
    return searchquery
  end
    
  def search(apiquery)
    
    results = @connection.search(apiquery, @session_key, @auth_token, :json).to_hash
    checkSessionCurrency
    #@debug_notes << "<p" << results.to_s << "</p>"
    session[:results] = results
    page_num = 1
    apiquery.split('&').each do |param|
      if param.start_with?('pagenumber=')
        page_num = param.tr('pagenumber=', '').to_i
        break
      end
    end
  end
  
  #not implemented
  def retrieve(dbid, an, highlight)
    #@debug_notes << "...retrieving " << dbid << "--" << an << "--ST: " << @session_key.to_s << "--AT: " << @auth_token.to_s << "..."
    record = @connection.retrieve(dbid, an, highlight, @session_key, @auth_token, :json).to_hash
    checkSessionCurrency
    return record
  end
  
  def termsToHighlight(terms = "")
    if terms.present?
      words = terms.split(/\W+/)
      return words.join(",").to_s
    else
      return ""
    end
  end
  
  def switch_link(params,qurl)

    link = ""
    if params[:resultId].to_i > (params[:pagenumber].to_i * params[:resultsperpage].to_i)
      nextPage = params[:pagenumber].to_i + 1
      newParams = params
      newParams[:eds_action] = "GoToPage(" + nextPage.to_s + ")"
#      link = newParams.to_s
      options = generate_api_query(newParams)
      search(options)
    elsif params[:resultId].to_i < (((params[:pagenumber].to_i - 1) * params[:resultsperpage].to_i) + 1)
      nextPage = params[:pagenumber].to_i - 1
      newParams = params
      newParams[:eds_action] = "GoToPage(" + nextPage.to_s + ")"
#      link = newParams.to_s
      options = generate_api_query(newParams)
      search(options)
    end  
#    link << "<p>" << session[:results]['SearchResult'].to_s << "</p>"
    if session[:results]['SearchResult']['Data']['Records'].present?
      session[:results]['SearchResult']['Data']['Records'].each do |result|
        #link << "<p>Matching result number " << show_resultid(result).to_s << " to " << params[:resultId].to_s << "</p>"
        nextId = show_resultid(result).to_s
        if nextId == params[:resultId].to_s
          #link << "<p><strong>MATCHED: </strong>"
          nextAn = show_an(result).to_s
          nextDbId = show_dbid(result).to_s
          nextrId = params[:resultId].to_s
          nextHighlight = params[:q].to_s
          #link << nextAn.to_s << " - " << nextDbId.to_s << " - " << nextrId.to_s << " - " << nextHighlight.to_s << "</p>"
          link = request.fullpath.split("/switch")[0].to_s + "/" + nextDbId.to_s + "/" + nextAn.to_s + "/?resultId=" + nextrId.to_s + "&highlight=" + nextHighlight.to_s
        end        
      end
    end
    return link.to_s

  end

  def get_info
    numLimiters = 0
    #session[:debug_notes] = "Info is getting: " << @session_key << " and " << @auth_token << " and JSON"
    #before editing this, check with Don and Michelle
    session[:info] = @connection.info(@session_key, @auth_token, :json).to_hash
    checkSessionCurrency

    if session[:info].present?
      if session[:info]['AvailableSearchCriteria'].present?
        if session[:info]['AvailableSearchCriteria']['AvailableLimiters'].present?
          session[:info]['AvailableSearchCriteria']['AvailableLimiters'].each do |limiter|
            if limiter["Type"] == "select"
              numLimiters += 1
            end
          end
        end
      end
    end

    session[:numLimiters] = numLimiters
  end
  
  def debugNotes
    return @debug_notes
  end

  ############
  # File / Token Handling
  ############

  def clear_session_key
    session.delete(:session_key)
  end
  
  def get_session_key
    if session[:session_key].present?
      return session[:session_key].to_s
    else
      return "no session key"
    end
  end

  def token_file_exists?
    if File.exists?(token_file_location)
      return true
    end
    return Rails.root.to_s + "/token.txt"
  end
  
  def auth_file_exists?
    if File.exists?(auth_file_location)
      return true
    end
    return Rails.root.to_s + "/APIauthentication.txt"
  end
  
  def token_file_location
    if request.domain.to_s.include?("localhost")
      return "token.txt"
    end
    return Rails.root.to_s + "/token.txt"
  end
  
  def auth_file_location
    if request.domain.to_s.include?("localhost")
      return "APIauthentication.txt"
    end
    return Rails.root.to_s + "/APIauthentication.txt"
  end
  
  def has_valid_auth_token?
    token = timeout = timestamp = ''
    if token_file_exists?
      File.open(token_file_location,"r") {|f|
        if f.readlines.size <= 2
          return false
        end
      }
      File.open(token_file_location,"r") {|f|
          token = f.readline.strip
          timeout = f.readline.strip
          timestamp = f.readline.strip
      }
    else
      return false 
    end
    if Time.now.getutc.to_i < timestamp.to_i
      return true
    else
      return false
    end
  end
  
  def get_token_timeout
    timestamp = '';
    File.open(token_file_location,"r") {|f|
        token = f.readline.strip
        timeout = f.readline.strip
        timestamp = f.readline.strip
    }
    return Time.at(timestamp.to_i)
  end
  
  def writeAuthToken(auth_token)
    timeout = "1800"
    timestamp = Time.now.getutc.to_i + timeout.to_i
    timestamp = timestamp.to_s
    auth_token = auth_token.to_s
    
    if File.exists?(token_file_location)
      File.open(token_file_location,"w") {|f|
        f.write(auth_token)
        f.write("\n" + timeout)
        f.write("\n" + timestamp)
      }
    else
      File.new(token_file_location,"w") {|f|
        f.write(auth_token)
        f.write("\n" + timeout)
        f.write("\n" + timestamp)
      }
      File.chmod(664,token_file_location)
      File.open(token_file_location,"w") {|f|
        f.write(auth_token)
        f.write("\n" + timeout)
        f.write("\n" + timestamp)
      }
    end
  end
  
  def getAuthToken
    token = ''
    timeout = ''
    timestamp = ''
    if has_valid_auth_token?
      File.open(token_file_location,"r") {|f|
        token = f.readline.strip
      }
      return token
    end
    return token
  end


  ############
  # Linking Utilities
  ############

  # pulls <QueryString> from the results of the current search to serve as the baseURL for next request
  def generate_next_url
    if session[:results].present?
      url = HTMLEntities.new.decode(session[:results]['SearchRequestGet']['QueryString'])
      
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
      return url
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
      unless ((key == "search_field") or (key == "facetfilter") or (key == "pagenumber") or (key == "q") or (key == "dbid") or (key == "an"))
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

  ###########
  # Pagination
  ###########
  
  #display how many results are being shown      
  def show_results_per_page
    if params[:eds_action].present?
      if params[:eds_action].to_s.scan(/SetResultsPerPage/).length > 0
        rpp = params[:eds_action].to_s.gsub("SetResultsPerPage(","").gsub(")","").to_i
        return rpp
      end
    end
    if params[:resultsperpage].present?
      return params[:resultsperpage].to_i
    end
    return 20
  end
  
  #calculates total number of pages in results set
  def show_total_pages
    pages = show_total_hits / show_results_per_page
    return pages + 1
  end
  
  #get current page, which serves as a base for most pagination functions      
  def show_current_page
    if params[:eds_action].present?
      if params[:eds_action].scan(/GoToPage/).length > 0
        pagenum = params[:eds_action].to_s
        newpagenum = pagenum.gsub("GoToPage(","")
        newpagenum = newpagenum.gsub(")","")
        return newpagenum.to_i
      elsif params[:eds_action].scan(/SetResultsPerPage/).length > 0
        if params[:pagenumber].present?
          return params[:pagenumber].to_i
        else
          return 1
        end
      else
        return 1
      end
    end
    if params[:pagenumber].present?
      return params[:pagenumber].to_i
    end
    return 1
  end
        
  #display pagination at the top of the results list
  def show_compact_pagination
    previous_link = ''
    next_link = ''
    first_result_on_page_num = ((show_current_page - 1) * show_results_per_page) + 1
    last_result_on_page_num = first_result_on_page_num + show_results_per_page - 1
    if last_result_on_page_num > show_total_hits
      last_result_on_page_num = show_total_hits
    end
    page_info = "<strong>" + first_result_on_page_num.to_s + "</strong> - <strong>" + last_result_on_page_num.to_s + "</strong> of <strong>" + show_total_hits.to_s + "</strong>"
    if show_current_page > 1
      previous_page = show_current_page - 1
      previous_link = '<a href="' + request.fullpath.split("?")[0] + "?" + generate_next_url + "&eds_action=GoToPage(" + previous_page.to_s + ')">&laquo; Previous</a> | '
    end
    if (show_current_page * show_results_per_page) < show_total_hits
      next_page = show_current_page + 1
      next_link = ' | <a href="' + request.fullpath.split("?")[0] + "?" + generate_next_url + "&eds_action=GoToPage(" + next_page.to_s + ')">Next &raquo;</a>'
    end
    compact_pagination = previous_link + page_info + next_link
    return compact_pagination.html_safe
  end
        
  #bottom pagination.  commented out lines remove 'last page' link
  def show_pagination
    previous_link = ''
    next_link = ''
    page_num_links = ''
    
    if show_current_page > 1
      previous_page = show_current_page - 1
      previous_link = '<li class=""><a href="' + request.fullpath.split("?")[0] + "?" + generate_next_url + "&eds_action=GoToPage(" + previous_page.to_s + ')">&laquo; Previous</a></li>'
    else
      previous_link = '<li class="disabled"><a href="">&laquo; Previous</a></li>'
    end
    
    if (show_current_page * show_results_per_page) < show_total_hits
      next_page = show_current_page + 1
      next_link = '<li class=""><a href="' + request.fullpath.split("?")[0] + "?" + generate_next_url + "&eds_action=GoToPage(" + next_page.to_s + ')">Next &raquo;</a></li>'
    else
      next_link = '<li class="disabled"><a href="">Next &raquo;</a></li>'
    end
    
    if show_current_page >= 4
      page_num_links << '<li class=""><a href="' + request.fullpath.split("?")[0] + "?" + generate_next_url + "&eds_action=GoToPage(" + 1.to_s + ')">1</a></li>'
    end
    if show_current_page >= 5
      page_num_links << '<li class="disabled"><a href="">...</a></li>'
    end
    
    # show links to the two pages the the left and right (where applicable)
    bottom_page = show_current_page - 2
    if bottom_page <= 0
      bottom_page = 1
    end
    top_page = show_current_page + 2
    if top_page >= show_total_pages
      top_page = show_total_pages
    end
    (bottom_page..top_page).each do |i|
      unless i == show_current_page
        page_num_links << '<li class=""><a href="' + request.fullpath.split("?")[0] + "?" + generate_next_url + "&eds_action=GoToPage(" + i.to_s + ')">' + i.to_s + '</a></li>'          
      else
        page_num_links << '<li class="disabled"><a href="">' + i.to_s + '</a></li>'          
      end
    end

    # change number back to 4 if we fix the 'final page' error
    if show_total_pages >= (show_current_page + 3)
      page_num_links << '<li class="disabled"><a href="">...</a></li>'
    end
#          if show_total_pages >= (show_current_page + 3)
#            page_num_links << '<li class=""><a href="' + request.fullpath.split("?")[0] + "?" + generate_next_url + "&eds_action=GoToPage(" + show_total_pages.to_s + ')">' + show_total_pages.to_s + '</a></li>'          
#          end

    pagination_links = previous_link + next_link + page_num_links
    return pagination_links.html_safe
  end
        
  #############
  # Facet / Limiter Constraints Box
  #############
        
  #used when determining if the "constraints" partial should display
  def query_has_facetfilters?(localized_params = params)
    (generate_next_url.scan("facetfilter[]=").length > 0) or (generate_next_url.scan("limiter[]=").length > 0)
  end
  
  # should probably return a hash and let the view handle the HTML
  def show_applied_facets
    appliedfacets = '';
    if session[:results]['SearchRequestGet']['SearchCriteriaWithActions']['FacetFiltersWithAction'].present?
      session[:results]['SearchRequestGet']['SearchCriteriaWithActions']['FacetFiltersWithAction'].each do |appliedfacet|
        appliedfacet.each do |key, val|
          if key == "FacetValuesWithAction"
            val.each do |facetValue|
              appliedfacets << '<span class="appliedFilter constraint filter filter-format"><span class="filterName">' + facetValue['FacetValue']['Id'].to_s.gsub("EDS","").titleize + '</span><span class="filterValue">' + facetValue['FacetValue']['Value'].to_s.titleize + '</span><a class="btnRemove imgReplace" href="' + request.fullpath.split("?")[0] + "?" + generate_next_url + "&eds_action=" + CGI.escape(facetValue['RemoveAction'].to_s) + '">Remove filter</a></span>' 
            end
          end
        end
      end
    end
    return appliedfacets.html_safe        
  end

  # should return hash and let the view handle the HTML
  def show_applied_limiters
    appliedlimiters = '';
    if session[:results].present?
      if session[:results]['SearchRequestGet']['SearchCriteriaWithActions'].present?
        if session[:results]['SearchRequestGet']['SearchCriteriaWithActions']['LimitersWithAction'].present?
          session[:results]['SearchRequestGet']['SearchCriteriaWithActions']['LimitersWithAction'].each do |appliedLimiter|
            limiterLabel = "No Label"
            session[:info]['AvailableSearchCriteria']['AvailableLimiters'].each do |limiter|
              if limiter["Id"] == appliedLimiter["Id"]
                limiterLabel = limiter["Label"]
              end
            end
            if appliedLimiter["Id"] == "DT1"
              appliedLimiter["LimiterValuesWithAction"].each do |limiterValues|
                appliedlimiters << '<span class="appliedFilter constraint filter filter-format"><span class="filterName">' + limiterLabel.to_s.titleize + '</span><span class="filterValue">' + limiterValues["Value"].gsub("-01/"," to ").gsub("-12","") + '</span><a class="btnRemove imgReplace" href="' + request.fullpath.split("?")[0] + "?" + generate_next_url + "&eds_action=" + appliedLimiter["RemoveAction"].to_s + '">Remove limiter</a></span>'
              end
            else
              appliedlimiters << '<span class="appliedFilter constraint filter filter-format"><span class="filterValue">' + limiterLabel.to_s.titleize + '</span><a class="btnRemove imgReplace" href="' + request.fullpath.split("?")[0] + "?" + generate_next_url + "&eds_action=" + appliedLimiter["RemoveAction"].to_s + '">Remove limiter</a></span>'
            end
          end
        end
      end
    end
    return appliedlimiters.html_safe        
  end

  #############
  # Facets / Limiters sidebar
  #############

  # check to see if result has any facets.  crude, and I forget why I had to do a lenght check..
  def has_eds_facets?
    (show_facets.length > 5)
  end

  def show_numlimiters
    get_info
    return session[:numLimiters]
  end
        
  def show_limiters
    limiterCount = 0;
    limitershtml = '';
    unless session[:info].present?
      get_info
    end
    if session[:info]['AvailableSearchCriteria']['AvailableLimiters'].present?
      limitershtml << '<form class="form"><ul style="margin-bottom:0px">'
      session[:info]['AvailableSearchCriteria']['AvailableLimiters'].each do |limiter|
        if limiter["Type"] == "select"
          limiterChecked = false
          limiterAction = limiter["AddAction"].to_s.gsub('value','y')
          if session[:results].present?
            if session[:results]['SearchRequestGet']['SearchCriteriaWithActions'].present?
              if session[:results]['SearchRequestGet']['SearchCriteriaWithActions']['LimitersWithAction'].present?
                session[:results]['SearchRequestGet']['SearchCriteriaWithActions']['LimitersWithAction'].each do |appliedLimiter|
                  if appliedLimiter["Id"] == limiter["Id"]
                    limiterChecked = true
                    limiterAction = appliedLimiter["RemoveAction"].to_s
                  end
                end
              end
            end
          end
          limitershtml << "<li style='font-size:small;'>"
          limitershtml << check_box_tag("limiters", limiterAction, limiterChecked, :id => ("limiter-" + limiterCount.to_s), :style => "margin-top:-5px;")
          limitershtml << " " << limiter["Label"] << "</li>"
          limiterCount += 1
        end
      end
      limitershtml << '</ul></form>'
      return limitershtml.html_safe
    else
      return session[:info].to_s
    end
  end

  # should probably implement a slider, but this will get most queries
  # might consider a "custom" date range box as well
  def show_date_options
    dateString = ""
    timeObj = Time.new
    currentYear = timeObj.year
    fiveYearsPrior = currentYear - 5
    tenYearsPrior = currentYear - 10
    dateString << '<div class="facet_limit blacklight-date"><h5 class="twiddle">Date<i class="icon-chevron"></i></h5><ul style="display: block;">'
    dateString << '<li><a href="' << request.fullpath.split("?")[0] << "?" << generate_next_url << '&eds_action=addlimiter(DT1:' << fiveYearsPrior.to_s << '-01/' << currentYear.to_s << '-12)">Last 5 Years</a></li>'
    dateString << '<li><a href="' << request.fullpath.split("?")[0] << "?" << generate_next_url << '&eds_action=addlimiter(DT1:' << tenYearsPrior.to_s << '-01/' << currentYear.to_s << '-12)">Last 10 Years</a></li>'
    dateString << '</ul></div>'
    return dateString.html_safe
  end
	
  # show available facets
  def show_facets
    facets = '';
    if session[:results]['SearchResult']['AvailableFacets'].present?
      session[:results]['SearchResult']['AvailableFacets'].each do |facet|
        facets = facets + '<div class="facet_limit blacklight-' + facet['Id'] + '"><h5 class="twiddle">' + facet['Label'] + '<i class="icon-chevron"></i></h5><ul style="display: block;">'
        facet.each do |key, val|
          if key == "AvailableFacetValues"
            val.each do |facetValue|
              # the LINK should NOT be escaped
              # URL encode LINK - preserve the slashes without breaking the link - urlencode VALUES of parameters for escape character functionality
              facets = facets + '<li><a class="facet_select" href="' + request.fullpath.split("?")[0] + "?" + generate_next_url + "&eds_action=" + CGI.escape(facetValue['AddAction'].to_s) + '">' + facetValue['Value'].to_s.titleize + '</a> <span class="count">' + facetValue['Count'].to_s + '</li>'
            end
          end
        end
        facets = facets + '</ul></div>'
      end
    end
    return facets.html_safe
  end


  #############
  # Sort / Display / Record Count
  #############
	
  def show_sort_options
    sortDropdown = "";
    if session[:info]['AvailableSearchCriteria']['AvailableSorts'].present?
      session[:info]['AvailableSearchCriteria']['AvailableSorts'].each do |sortOption|
        sortDropdown << '<li><a href="' << request.fullpath.split("?")[0] + "?" + generate_next_url << '&eds_action=' << sortOption["AddAction"].to_s << '">' << sortOption["Label"].to_s << '</a></li>'
      end
    end
    return sortDropdown.html_safe
  end

  def show_view_option
    uri = Addressable::URI.parse(request.fullpath.split("?")[0] + "?" + generate_next_url)
    newUri = uri.query_values
    if newUri['view'].present?
      view_option = newUri['view'].to_s
    else
      view_option = "detailed"
    end
    return view_option
  end

  # question - why am I not looking in the "generate Next URL"?
  def show_current_sort
    allsorts = '';
    if params[:eds_action].present?
      if params[:eds_action].to_s.scan(/setsort/).length > 0
        currentSort = params[:eds_action].to_s.gsub("setsort(","").gsub(")","")
        if session[:info]['AvailableSearchCriteria']['AvailableSorts'].present?
          session[:info]['AvailableSearchCriteria']['AvailableSorts'].each do |sortOption|
            if sortOption['Id'] == currentSort
              return "Sort by " << sortOption["Label"]
            end
          end
        end              
      end
    end
    if params[:sort].present?
      if session[:info]['AvailableSearchCriteria']['AvailableSorts'].present?
        session[:info]['AvailableSearchCriteria']['AvailableSorts'].each do |sortOption|
          if sortOption['Id'].to_s == params[:sort].to_s
            return "Sort by " << sortOption["Label"]
          end
        end
      end            
    end
    return 'Sort by Relevance'
  end
  	
  ###############
  # Results List
  ###############

  def show_total_hits
    return session[:results]['SearchResult']['Statistics']['TotalHits']
  end

  def has_titlesource?(result)
    if result['Items'].present?
      result['Items'].each do |item|
        if item['Group'].downcase == "src"
          return true
        end
      end
    end
    return false
  end

  def show_titlesource(result)
    source = ''
    flag = 0
    if result['Items'].present?
      result['Items'].each do |item|
        # turn to case insensitive (also look at other matching in autors, title, etc.)
        if item['Group'].downcase == "src" and flag == 0
          source = processAPItags(item['Data'].to_s)
          flag = 1
        end
      end
    end
    return source.html_safe
  end

  def has_subjects?(result)
    if result['RecordInfo'].present?
      if result['RecordInfo']['BibRecord'].present?
        if result['RecordInfo']['BibRecord']['BibEntity'].present?
          if result['RecordInfo']['BibRecord']['BibEntity']['Subjects'].present?
            if result['RecordInfo']['BibRecord']['BibEntity']['Subjects'].count > 0
              return true
            end
          end
        end
      end
    end
    return false  
  end

  def show_subjects(result)
    # check to see if there is an ITEM GROUP
    subject_array = []
    if result['RecordInfo'].present?
      if result['RecordInfo']['BibRecord'].present?
        if result['RecordInfo']['BibRecord']['BibEntity'].present?
          if result['RecordInfo']['BibRecord']['BibEntity']['Subjects'].present?
            result['RecordInfo']['BibRecord']['BibEntity']['Subjects'].each do |subject|
              if subject['SubjectFull']
                url_vars = {"q" => '"' + subject['SubjectFull'].to_s + '"', "search_field" => "subject"}
                link2 = generate_next_url_newvar_from_hash(url_vars) << "&eds_action=GoToPage(1)"
                if params[:dbid].present?
                  subject_link = '<a href="' + request.fullpath.split("/" + params[:dbid])[0] + "?" + link2 + '">' + subject['SubjectFull'].to_s + '</a>'
                else
                  subject_link = '<a href="' + request.fullpath.split("?")[0] + "?" + link2 + '">' + subject['SubjectFull'].to_s + '</a>'
                end
                subject_array.push(subject_link)
              end
            end
          end
        end
      end
    end
    subject_string = ''
    subject_string = subject_array.join(", ")
    return subject_string.html_safe
  end

  def has_pubdate?(result)
    if result['RecordInfo'].present?
      if result['RecordInfo']['BibRecord'].present?
        if result['RecordInfo']['BibRecord']['BibRelationships'].present?
          if result['RecordInfo']['BibRecord']['BibRelationships']['IsPartOfRelationships'].present?
            result['RecordInfo']['BibRecord']['BibRelationships']['IsPartOfRelationships'].each do |isPartOfRelationship|
              if isPartOfRelationship['BibEntity'].present?
                if isPartOfRelationship['BibEntity']['Dates'].present?
                  isPartOfRelationship['BibEntity']['Dates'].each do |date|
                    if date['Type'] == "published"
                      return true
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    return false
  end

  def show_pubdate(result)
    # check to see if there is a PubDate ITEM
    # Wiki Page on ITEM GROUPS
    flag = 0
    pubdate = ''
    if result['RecordInfo'].present?
      if result['RecordInfo']['BibRecord'].present?
        if result['RecordInfo']['BibRecord']['BibRelationships'].present?
          if result['RecordInfo']['BibRecord']['BibRelationships']['IsPartOfRelationships'].present?
            result['RecordInfo']['BibRecord']['BibRelationships']['IsPartOfRelationships'].each do |isPartOfRelationship|
              if isPartOfRelationship['BibEntity'].present?
                if isPartOfRelationship['BibEntity']['Dates'].present?
                  isPartOfRelationship['BibEntity']['Dates'].each do |date|
                    if date['Type'] == "published" and flag == 0
                      flag = 1
                      if date['M'].present? and date['D'].present? and date['Y'].present?
                        pubdate << date['M'] << "/" << date['D'] << "/" << date['Y']
                      elsif date['M'].present? and date['Y'].present?
                        pubdate << date['M'] << "/" << date['Y']
                      elsif date['Y'].present?
                        pubdate << date['Y']
                      else
                        pubdate << "Not available."
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    return pubdate
  end

  def has_pubtype?(result)
    return result['Header']['PubType'].present?
  end

  def show_pubtype(result)
    if has_pubtype?(result)
      return result['Header']['PubType']
    end
    return ''
  end
  
  def has_pubtypeid?(result)
    return result['Header']['PubTypeId'].present?
  end

  def show_pubtypeid(result)
    if has_pubtypeid?(result)
      return result['Header']['PubTypeId']
    end
    return ''
  end
  
  def has_coverimage?(result)
    if result['ImageInfo'].present?
      result['ImageInfo'].each do |coverArt|
        if coverArt['Size'] == 'thumb'
          return true
        end
      end
    end
    return false
  end

  def show_coverimage_link(result)
    artUrl = ''
    flag = 0
    if result['ImageInfo'].present?
      result['ImageInfo'].each do |coverArt|
        if coverArt['Size'] == 'thumb' and flag == 0
          artUrl << coverArt['Target']
          flag = 1
        end
      end
    end
    return artUrl    
  end
    
  def has_abstract?(result)
    if result['Items'].present?
      result['Items'].each do |item|
        if item['Group'].present?
          if item['Group'] == "Ab"
            return true
          end          
        end
      end
    end
    return false
  end

  def show_abstract(result)
    abstractString = ''
    if result['Items'].present?
      result['Items'].each do |item|
        if item['Group'].present?
          if item['Group'] == "Ab"
            abstractString << item['Data']
          end          
        end
      end
    end
    abstract = HTMLEntities.new.decode abstractString
    return abstract.html_safe
  end

  def has_authors?(result)
    if result['Items'].present?
      result['Items'].each do |item|
        if item['Group'].present?
          if item['Group'] == "Au"
            return true
          end
        end
      end
    end
    if result['RecordInfo'].present?
      if result['RecordInfo']['BibRecord'].present?
        if result['RecordInfo']['BibRecord']['BibRelationships'].present?
          if result['RecordInfo']['BibRecord']['BibRelationships']['HasContributorRelationships'].present?
            result['RecordInfo']['BibRecord']['BibRelationships']['HasContributorRelationships'].each do |contributor|
              if contributor['PersonEntity'].present?
                return true
              end
            end
          end
        end
      end
    end
    return false
  end

  # this should make use of AddQuery / RemoveQuery - but there might be a conflict with the "q" variable  
  def show_authors(result)
    author_array = []
    if result['Items'].present?
      flag = 0
      authorString = []
      result['Items'].each do |item|
        if item['Group'].present?
          if item['Group'] == "Au"
            # let Don and Michelle know what this cleaner function does
            newAuthor = processAPItags(item['Data'].to_s)
            # i'm duplicating the semicolor - fix
            newAuthor.gsub!("<br />","; ")
            authorString.push(newAuthor)
            flag = 1
          end
        end
      end
      if flag == 1
        return authorString.join("; ").html_safe
      end
    end

    if result['RecordInfo'].present?
      if result['RecordInfo']['BibRecord'].present?
        if result['RecordInfo']['BibRecord']['BibRelationships'].present?
          if result['RecordInfo']['BibRecord']['BibRelationships']['HasContributorRelationships'].present?
            result['RecordInfo']['BibRecord']['BibRelationships']['HasContributorRelationships'].each do |contributor|
              if contributor['PersonEntity'].present?
                if contributor['PersonEntity']['Name'].present?
                  if contributor['PersonEntity']['Name']['NameFull'].present?
                    url_vars = {"q" => '"' + contributor['PersonEntity']['Name']['NameFull'].gsub(",","").gsub("%2C","").to_s + '"', "search_field" => "author"}
                    link2 = generate_next_url_newvar_from_hash(url_vars)
                    author_link = '<a href="' + request.fullpath.split("?")[0] + "?" + link2 + '">' + contributor['PersonEntity']['Name']['NameFull'].to_s + '</a>'
                    author_array.push(author_link)
                  end
                end
              end
            end
            return author_array.join("; ").html_safe
          end
        end
      end
    end
    return ''
  end

  def show_resultid(result)
    return result['ResultId'].to_s
  end
	
  def show_title(result)
    result['Items'].each do |item|
      if item['Group'] == 'Ti'
        return HTMLEntities.new.decode(item['Data']).html_safe
      end
    end
    titles = []
    if result['RecordInfo'].present?
      if result['RecordInfo']['BibRecord'].present?
        if result['RecordInfo']['BibRecord']['BibEntity'].present?
          if result['RecordInfo']['BibRecord']['BibEntity']['Titles'].present?
            result['RecordInfo']['BibRecord']['BibEntity']['Titles'].each do |title|
              titles.push title['TitleFull'].to_s
            end
          end
        end
      end
      return titles.join(" / ").html_safe
    end
    return "Title not available."
  end
  
  def show_results_array
    @results.inspect
  end

  def has_full_text_on_screen?(result)
    if result['FullText'].present?
      if result['FullText']['Text'].present?
        if result['FullText']['Text']['Availability'].present?
          if result['FullText']['Text']['Availability'] == "1"
            return true
          end
        end
      end
    end
  end
  
  def show_full_text_on_screen(result)
    if result['FullText'].present?
      if result['FullText']['Text'].present?
        if result['FullText']['Text']['Availability'].present?
          if result['FullText']['Text']['Availability'] == "1"
            return HTMLEntities.new.decode(result['FullText']['Text']['Value'])
          end
        end
      end
    end
  end

  ################
  # Full Text Links
  ################

  def has_any_fulltext?(result)
    if has_pdf?(result)
      return true
    elsif has_html?(result)
      return true
    elsif has_fulltext?(result)
      return true
    end
    return false
  end

  def show_an(result)
    if result['Header'].present?
        if result['Header']['An'].present?
          an = result['Header']['An'].to_s
        end
    end
    return an    
  end

  def show_dbid(result)
    if result['Header'].present?
        if result['Header']['DbId'].present?
          dbid = result['Header']['DbId'].to_s
        end
    end
    return dbid    
  end

  def show_detail_link(result, resultId = "0", highlight = "")
    link = ""
    if result['Header'].present?
      if result['Header']['DbId'].present?
        if result['Header']['An'].present?
          link << 'articles/' << result['Header']['DbId'].to_s << '/' << result['Header']['An'] << '/'
          if resultId.to_i > "0".to_i and highlight != "" 
            link << '?resultId=' << resultId.to_s << '&highlight=' << highlight.to_s
          elsif resultId.to_i > "0".to_i
            link << '?resultId=' << resultId.to_s
          elsif highlight != ""
            link << '?highlight' << highlight.to_s
          end
        end
      end
    end
    return link
  end

  def show_best_fulltext_link(result)
    if has_pdf?(result)
      return show_pdf_title_link(result)
    elsif has_html?(result)
      # this should point to detailed record when implemented
      return show_detail_link(result)
    elsif has_fulltext?(result)
      return best_customlink(result)
    end
    return ''
  end
  
  # generate full text link for the detailed record area (not the title link)
  def show_best_fulltext_link_detail(result)
    if has_pdf?(result)
      link = '<a href="' + show_pdf_title_link(result) + '">PDF Full Text</a>'
    elsif has_html?(result)
      link = '<a href="' + show_best_fulltext_link(result) + '" target="_blank">HTML Full Text</a>'
    elsif has_fulltext?(result)
      link = best_customlink_detail(result)
    else
      link = ''
    end
    return link.html_safe
  end

  def has_pdf?(result)
    if result['FullText'].present?
      if result['FullText']['Links'].present?
        result['FullText']['Links'].each do |link|
          if link['Type'] == "pdflink"
            return true
          end
        end
      end
    end
    return false
  end

  def has_html?(result)
    if result['FullText'].present?
      if result['FullText']['Text'].present?
        if result['FullText']['Text']['Availability'].present?
          if result['FullText']['Text']['Availability'].to_s == "1"
            return true
          end
        end
      end
    end
    return false
  end

  def has_fulltext?(result)
    if result['FullText'].present?
      if result['FullText']['CustomLinks'].present?
        result['FullText']['CustomLinks'].each do |customLink|
          if customLink['Category'] == "fullText"
            return true
          end
        end
      end
    end
    return false
  end
  
  def show_plink(result)
    plink = ''
    if result['PLink'].present?
      plink << result['PLink']
    end
    return plink
  end

  def show_pdf_title_link(result)
    title_pdf_link = ''
    if result['Header']['DbId'].present? and result['Header']['An'].present?
      title_pdf_link << request.fullpath.split("?")[0] << "/" << result['Header']['DbId'].to_s << "/" << result['Header']['An'].to_s << "/fulltext"
    end
    new_link = Addressable::URI.unencode(title_pdf_link.to_s)
    return new_link
  end

  def show_pdf_link(record)
    pdf_link = ''
    if record['FullText'].present?
      if record['FullText']['Links'].present?
        record['FullText']['Links'].each do |link|
          if link['Type'] == "pdflink"
            pdf_link << link['Url']
          end
        end
      end
    end
    return pdf_link
  end
    
  def show_fulltext(result)
    fulltext_links = []
    if result['FullText'].present?
      if result['FullText']['CustomLinks'].present?
        result['FullText']['CustomLinks'].each do |customLink|
          if customLink['Category'] == "fullText" and customLink['Text'].present?
            fulltext_links << '<a href="' + customLink['Url'] + '">' + customLink['Text'] + '</a>'              
          elsif customLink['Category'] == "fullText"
            fulltext_links << '<a href="' + customLink['Url'] + '">Full Text via CustomLink' + customLink.to_s + '</a> '
          end
        end
      end
    end
    return fulltext_links.join(", ").html_safe  
  end

  # show prioritized custom links
  def best_customlink(result)
    fulltext_links = ''
    flag = 0
    if result['FullText'].present?
      if result['FullText']['CustomLinks'].present?
        result['FullText']['CustomLinks'].each do |customLink|
          if customLink['Category'] == "fullText" and flag == 0
            fulltext_links << customLink['Url']
            flag = 1
          end
        end
      end
    end
    return fulltext_links
  end

  def best_customlink_detail(result)
    fulltext_links = ''
    flag = 0
    if result['FullText'].present?
      if result['FullText']['CustomLinks'].present?
        result['FullText']['CustomLinks'].each do |customLink|
          if customLink['Category'] == "fullText" and flag == 0 and customLink['Text'].present? and customLink['Icon'].present?
            fulltext_links << '<a href="' + customLink['Url'] + '" target="_blank"><img src="' + customLink['Icon'] + '" border="0">' + customLink['Text'] + '</a>'
            flag = 1
          elsif customLink['Category'] == "fullText" and flag == 0 and customLink['Text'].present?
            flag = 1
            fulltext_links << '<a href="' + customLink['Url'] + '" target="_blank">' + customLink['Text'] + '</a>'
          elsif customLink['Category'] == "fullText" and flag == 0 and customLink['Icon'].present?
            fulltext_links << '<a href="' + customLink['Url'] + '" target="_blank"><img src="' + customLink['Icon'] + '" border="0"></a>'
            flag = 1            
          elsif customLink['Category'] == "fullText" and flag == 0
            fulltext_links << '<a href="' + customLink['Url'] + '" target="_blank">Full Text via Custom Link</a>'
            flag = 1            
          end
        end
      end
    end
    return fulltext_links
  end
  
  def has_ill?(result)
      if result['CustomLinks'].present?
        result['CustomLinks'].each do |customLink|
          if customLink['Category'] == "ill"
            return true
          end
        end
      end
    return false
  end
  
  def show_ill(result)
    fulltext_links = ''
    if result['CustomLinks'].present?
      result['CustomLinks'].each do |customLink|
        if customLink['Category'] == "ill"
          fulltext_links << '<a href="' << customLink['Url'] << '">Request via Interlibrary Loan</a> '
        end
      end
    end
    return fulltext_links.html_safe  
  end
  
  ################
  # Debug Functions
  ################
	
  def show_query_string
    return session[:results]['queryString']
  end

end