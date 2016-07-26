
module Blacklight::API_Interaction
  require_relative './connection_handler' #connection class
  ###########
  # API Interaction
  ###########

  # called at the beginning of every page load
  def eds_connect

    # use session[:debugNotes] to store any debug text
    # this will display if you render the _debug partial
    #session[:debugNotes] = ""

    # creates EDS API connection object, initializing it with application login credentials
    begin
      @connection = ConnectionHandler.new(2)
      File.open(auth_file_location,"r") {|f|
        @api_userid = f.readline.strip
        @api_password = f.readline.strip
        @api_profile = f.readline.strip
      }
      @connection.ip_init(@api_profile, 'n')
      @connection.ip_authenticate(:json)
      @session_key = @connection.create_session
      get_info
    rescue StandardError => e
      throw :eds_connection_error
    end


    # if authenticated_user?
    #   session[:debugNotes] << "<p>Sending NO as guest.</p>"
    #   @connection.uid_init(@api_userid, @api_password, @api_profile, 'n')
    # else
    #   session[:debugNotes] << "<p>Sending YES as guest.</p>"
    #   @connection.uid_init(@api_userid, @api_password, @api_profile, 'y')      
    # end
    #
    # # generate a new authentication token if their isn't one or the one stored on server is invalid or expired
    # if has_valid_auth_token?
    #   @auth_token = getAuthToken
    # else
    #   @connection.uid_authenticate(:json)
    #   @auth_token = @connection.show_auth_token
    #   writeAuthToken(@auth_token)
    # end
    #
    # # generate a new session key if there isn't one, or if the existing one is invalid
    # if session[:session_key].present?
    #   if session[:session_key].include?('Error')
    #     @session_key = @connection.create_session(@auth_token)
    #     session[:session_key] = @session_key
    #     get_info
    #   else 
    #     @session_key = session[:session_key]
    #   end
    # else
    #   @session_key = @connection.create_session(@auth_token, 'n')
    #   session[:session_key] = @session_key
    #   get_info
    # end
    #
    # # at this point, we should have a valid authentication and session token

  end

  # after basic functions like SEARCH, INFO, and RETRIEVE, check to make sure a new session token wasn't generated
  # if it was, use the new session key from here on out
  def checkSessionCurrency
    currentSessionKey = @connection.show_session_token
    if currentSessionKey != get_session_key
      session[:session_key] = currentSessionKey
      @session_key = currentSessionKey
      get_info
    end
  end

  # generates parameters for the API call given URL parameters
  # options is usually the params hash
  # this function strips out unneeded parameters and reformats them to form a string that the API accepts as input
  def generate_api_query(options)

    #removing Rails and Blacklight parameters
    options.delete("action")
    options.delete("controller")
    options.delete("utf8")

    #translate Blacklight search_field into query index
    if options["search_field"].present?
      if options["search_field"] == "author"
        fieldcode = "AU:"
      elsif options["search_field"] == "subject"
        fieldcode = "SU:"
      elsif options["search_field"] == "title"
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
    newoptions["query-1"] = newoptions["query-1"].gsub(",","")
    uri.query_values = newoptions
    searchquery = uri.query
    searchtermindex = searchquery.index('query-1=') + 8
    searchquery.insert searchtermindex, searchquery_extras

    # , : ( ) - unencoding expected punctuation
    searchquery = searchquery.gsub('%28','(').gsub('%3A',':').gsub('%29',')').gsub('%23',',').gsub('%26', '&').gsub('%3B', ';').gsub('&quot', '%22')
    return searchquery
  end

  # main search function.  accepts string to be tacked on to API endpoint URL
  def search(apiquery)
    results = @connection.search(apiquery, @session_key, @auth_token, :json).to_hash

    #update session_key if new one was generated in the call
    checkSessionCurrency
    #results are stored in the session to facilitate faster navigation between detailed records and results list without needed a new API call
    @results = results

    #session[:apiquery] = apiquery
  end

  def retrieve(dbid, an, highlight = "")
    #debugNotes << "HIGHLIGHTBEFORE:" << highlight.to_s
    highlight.downcase!
    highlight.gsub! ',and,',','
    highlight.gsub! ',or,',','
    highlight.gsub! ',not,',','
    #debugNotes << "HIGHLIGHTAFTER: " << highlight.to_s
    record = @connection.retrieve(dbid, an, highlight, @session_key, @auth_token, :json).to_hash
    #debugNotes << "RECORD: " << record.to_s
    #update session_key if new one was generated in the call
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

  # helper function for iterating through results from 
  def switch_link(params,qurl)

    # check to see if the user is navigating to a record that was not included in the current page of results
    # if so, run a new search API call, getting the appropriate page of results
    if params[:resultId].to_i > (params[:pagenumber].to_i * params[:resultsperpage].to_i)
      nextPage = params[:pagenumber].to_i + 1
      newParams = params
      newParams[:eds_action] = "GoToPage(" + nextPage.to_s + ")"
      options = generate_api_query(newParams)
      search(options)
    elsif params[:resultId].to_i < (((params[:pagenumber].to_i - 1) * params[:resultsperpage].to_i) + 1)
      nextPage = params[:pagenumber].to_i - 1
      newParams = params
      newParams[:eds_action] = "GoToPage(" + nextPage.to_s + ")"
      options = generate_api_query(newParams)
      search(options)
    end  

    link = ""
    # generate the link for the target record
    if @results && @results['SearchResult'] && @results['SearchResults']['Data'] && @results['SearchResult']['Data']['Records'].present?
      @results['SearchResult']['Data']['Records'].each do |result|
        nextId = show_resultid(result).to_s
        if nextId == params[:resultId].to_s
          nextAn = show_an(result).to_s
          nextDbId = show_dbid(result).to_s
          nextrId = params[:resultId].to_s
          nextHighlight = params[:q].to_s
          link = request.fullpath.split("/switch")[0].to_s + "/" + nextDbId.to_s + "/" + nextAn.to_s + "/?resultId=" + nextrId.to_s + "&highlight=" + nextHighlight.to_s
        end        
      end
    end
    return link.to_s

  end

  # calls the INFO API method
  # counts how many limiters are available
  def get_info

    numLimiters = 0
    @info = @connection.info(@session_key, @auth_token, :json).to_hash
    checkSessionCurrency

    if @info.present?
      if @info['AvailableSearchCriteria'].present?
        if @info['AvailableSearchCriteria']['AvailableLimiters'].present?
          @info['AvailableSearchCriteria']['AvailableLimiters'].each do |limiter|
            if limiter["Type"] == "select"
              numLimiters += 1
            end
          end
        end
      end
    end

    session[:numLimiters] = numLimiters
  end
end
