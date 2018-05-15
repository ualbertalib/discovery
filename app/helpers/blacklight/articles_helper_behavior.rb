# frozen_string_literal: true

##
# Copyright 2013 EBSCO Information Services
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

module Blacklight::ArticlesHelperBehavior
  ############
  # Utility functions and libraries
  ############

  require 'fileutils' # for interacting with files
  require 'addressable/uri' # for manipulating URLs in the interface
  require 'htmlentities' # for deconding/encoding URLs
  require 'cgi'
  require 'open-uri'

  def html_unescape(text)
    CGI.unescape(text)
  end

  def deep_clean(parameters)
    tempArray = []
    parameters.each do |k, v|
      if v.nil?
        clean_key = h(k)
        tempArray.push(clean_key)
      else
        if v.is_a?(Array)
          deeperClean = deep_clean(v)
          parameters[k] = deeperClean
        else
          parameters[k] = h(v)
        end
      end
    end
    parameters = tempArray unless tempArray.empty?
    parameters
  end

  # cleans response from EBSCO API
  def processAPItags(apiString)
    processed = HTMLEntities.new.decode apiString
    processed.html_safe
  end

  ###########
  # API Interaction
  ###########

  # called at the beginning of every page load
  def eds_connect
    # use session[:debugNotes] to store any debug text
    # this will display if you render the _debug partial
    session[:debugNotes] = ''

    # creates EDS API connection object, initializing it with application login credentials
    @connection = ConnectionHandler.new(2)
    File.open(auth_file_location, 'r') do |f|
      @api_userid = f.readline.strip
      @api_password = f.readline.strip
      @api_profile = f.readline.strip
    end

    @connection.ip_init(@api_profile, 'n')
    @connection.ip_authenticate(:json)
    @session_key = @connection.create_session
    get_info

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
    # removing Rails and Blacklight parameters
    options.delete('action')
    options.delete('controller')
    options.delete('utf8')

    # translate Blacklight search_field into query index
    fieldcode = if options['search_field'].present?
                  if options['search_field'] == 'author'
                    'AU:'
                  elsif options['search_field'] == 'subject'
                    'SU:'
                  elsif options['search_field'] == 'title'
                    'TI:'
                  else
                    ''
                  end
                else
                  ''
                end

    # should write something to allow this to be overridden
    searchmode = 'AND'

    # build 'query-1' API URL parameter
    searchquery_extras = searchmode + ',' + fieldcode

    # filter to make sure the only parameters put into the API query are those that are expected by the API
    edsKeys = ['eds_action', 'q', 'query-1', 'facetfilter[]', 'facetfilter', 'sort', 'includefacets', 'searchmode', 'view', 'resultsperpage', 'sort', 'pagenumber', 'highlight', 'limiter', 'limiter[]']
    edsSubset = {}
    options.each do |key, value|
      edsSubset[key] = value if edsKeys.include?(key)
    end

    # rename parameters to expected names
    # action and query-1 were renamed due to Rails and Blacklight conventions respectively
    mappings = { 'eds_action' => 'action', 'q' => 'query-1' }
    newoptions = Hash[edsSubset.map { |k, v| [mappings[k] || k, v] }]

    # repace the raw query, adding searchmode and fieldcode
    changeQuery = newoptions['query-1']
    uri = Addressable::URI.new
    newoptions['query-1'] = newoptions['query-1'].delete(',')
    uri.query_values = newoptions
    searchquery = uri.query
    searchtermindex = searchquery.index('query-1=') + 8
    searchquery.insert searchtermindex, searchquery_extras

    # , : ( ) - unencoding expected punctuation
    searchquery = searchquery.gsub('%28', '(').gsub('%3A', ':').gsub('%29', ')').gsub('%23', ',').gsub('%26', '&').gsub('%3B', ';').gsub('&quot', '%22')
    searchquery
  end

  # main search function.  accepts string to be tacked on to API endpoint URL
  def search(apiquery)
    results = @connection.search(apiquery, @session_key, @auth_token, :json).to_hash

    # update session_key if new one was generated in the call
    checkSessionCurrency

    # results are stored in the session to facilitate faster navigation between detailed records and results list without needed a new API call
    session[:results] = results
    session[:apiquery] = apiquery
  end

  def retrieve(dbid, an, highlight = '')
    # debugNotes << "HIGHLIGHTBEFORE:" << highlight.to_s
    highlight.downcase!
    highlight.gsub! ',and,', ','
    highlight.gsub! ',or,', ','
    highlight.gsub! ',not,', ','
    # debugNotes << "HIGHLIGHTAFTER: " << highlight.to_s
    record = @connection.retrieve(dbid, an, highlight, @session_key, @auth_token, :json).to_hash
    # debugNotes << "RECORD: " << record.to_s
    # update session_key if new one was generated in the call
    checkSessionCurrency

    record
  end

  def termsToHighlight(terms = '')
    if terms.present?
      words = terms.split(/\W+/)
      words.join(',').to_s
    else
      ''
    end
  end

  # helper function for iterating through results from
  def switch_link(params, _qurl)
    # check to see if the user is navigating to a record that was not included in the current page of results
    # if so, run a new search API call, getting the appropriate page of results
    if params[:resultId].to_i > (params[:pagenumber].to_i * params[:resultsperpage].to_i)
      nextPage = params[:pagenumber].to_i + 1
      newParams = params
      newParams[:eds_action] = 'GoToPage(' + nextPage.to_s + ')'
      options = generate_api_query(newParams)
      search(options)
    elsif params[:resultId].to_i < (((params[:pagenumber].to_i - 1) * params[:resultsperpage].to_i) + 1)
      nextPage = params[:pagenumber].to_i - 1
      newParams = params
      newParams[:eds_action] = 'GoToPage(' + nextPage.to_s + ')'
      options = generate_api_query(newParams)
      search(options)
    end

    link = ''
    # generate the link for the target record
    if session[:results] && session[:results]['SearchResult'] && session[:results]['SearchResults']['Data'] && session[:results]['SearchResult']['Data']['Records'].present?
      session[:results]['SearchResult']['Data']['Records'].each do |result|
        nextId = show_resultid(result).to_s
        next unless nextId == params[:resultId].to_s
        nextAn = show_an(result).to_s
        nextDbId = show_dbid(result).to_s
        nextrId = params[:resultId].to_s
        nextHighlight = params[:q].to_s
        link = request.fullpath.split('/switch')[0].to_s + '/' + nextDbId.to_s + '/' + nextAn.to_s + '/?resultId=' + nextrId.to_s + '&highlight=' + nextHighlight.to_s
      end
    end
    link.to_s
  end

  # calls the INFO API method
  # counts how many limiters are available
  def get_info
    numLimiters = 0
    session[:info] = @connection.info(@session_key, @auth_token, :json).to_hash
    checkSessionCurrency

    if session[:info].present?
      if session[:info]['AvailableSearchCriteria'].present?
        if session[:info]['AvailableSearchCriteria']['AvailableLimiters'].present?
          session[:info]['AvailableSearchCriteria']['AvailableLimiters'].each do |limiter|
            numLimiters += 1 if limiter['Type'] == 'select'
          end
        end
      end
    end

    session[:numLimiters] = numLimiters
  end

  ############
  # File / Token Handling / End User Auth
  ############

  def authenticated_user?
    return true if user_signed_in?
    # need to define function for detecting on-campus IP ranges
    false
  end

  def clear_session_key
    session.delete(:session_key)
  end

  def get_session_key
    if session[:session_key].present?
      session[:session_key].to_s
    else
      'no session key'
    end
  end

  def token_file_exists?
    return true if File.exist?(token_file_location)
    Rails.root.to_s + '/token.txt'
  end

  def auth_file_exists?
    return true if File.exist?(auth_file_location)
    Rails.root.to_s + '/APIauthentication.txt'
  end

  def token_file_location
    return 'token.txt' if request.domain.to_s.include?('localhost')
    Rails.root.to_s + '/token.txt'
  end

  def auth_file_location
    return 'APIauthentication.txt' if request.domain.to_s.include?('localhost')
    Rails.root.to_s + '/APIauthentication.txt'
  end

  # returns true if the authtoken stored in token.txt is valid
  # false if otherwise
  def has_valid_auth_token?
    token = timeout = timestamp = ''
    if token_file_exists?
      File.open(token_file_location, 'r') do |f|
        return false if f.readlines.size <= 2
      end
      File.open(token_file_location, 'r') do |f|
        token = f.readline.strip
        timeout = f.readline.strip
        timestamp = f.readline.strip
      end
    else
      return false
    end
    if Time.now.getutc.to_i < timestamp.to_i
      return true
    else
      # session[:debugNotes] << "<p>Looks like the auth token is out of date.. It expired at " << Time.at(timestamp.to_i).to_s << "</p>"
      return false
    end
  end

  def get_token_timeout
    timestamp = ''
    File.open(token_file_location, 'r') do |f|
      token = f.readline.strip
      timeout = f.readline.strip
      timestamp = f.readline.strip
    end
    Time.at(timestamp.to_i)
  end

  # writes an authentication token to token.txt.
  # will create token.txt if it does not exist
  def writeAuthToken(auth_token)
    timeout = '1800'
    timestamp = Time.now.getutc.to_i + timeout.to_i
    timestamp = timestamp.to_s
    auth_token = auth_token.to_s

    if File.exist?(token_file_location)
      File.open(token_file_location, 'w') do |f|
        f.write(auth_token)
        f.write("\n" + timeout)
        f.write("\n" + timestamp)
      end
    else
      File.new(token_file_location, 'w') do |f|
        f.write(auth_token)
        f.write("\n" + timeout)
        f.write("\n" + timestamp)
      end
      File.chmod(664, token_file_location)
      File.open(token_file_location, 'w') do |f|
        f.write(auth_token)
        f.write("\n" + timeout)
        f.write("\n" + timestamp)
      end
    end
  end

  def getAuthToken
    token = ''
    timeout = ''
    timestamp = ''
    if has_valid_auth_token?
      File.open(token_file_location, 'r') do |f|
        token = f.readline.strip
      end
      return token
    end
    token
  end

  ############
  # Linking Utilities
  ############

  # pulls <QueryString> from the results of the current search to serve as the baseURL for next request
  def generate_next_url
    if session[:results].present?
      url = HTMLEntities.new.decode(session[:results]['SearchRequestGet']['QueryString'])

      # blacklight expects the search term to be in the parameter 'q'.
      # q is moved back to 'query-1' in 'generate_api_query'
      # should probably pull from Info method to determine replacement strings
      # i could turn the query into a Hash, but available functions to do so delete duplicated params (Addressable)
      url.gsub!('query-1=AND,TI:', 'q=')
      url.gsub!('query-1=AND,AU:', 'q=')
      url.gsub!('query-1=AND,SU:', 'q=')
      url.gsub!('query-1=AND,', 'q=')

      # Rails framework doesn't allow repeated params.  turning these into arrays fixes it.
      url.gsub!('facetfilter=', 'facetfilter[]=')
      url.gsub!('limiter=', 'limiter[]=')

      # i should probably pull this from the query, not the URL
      url << '&search_field=' << params[:search_field].to_s if params[:search_field].present?
      url.gsub('&sort=relevance', '') # HACK: to get rid of buggy sort behaviour. Sam Popowich
    else
      ''
    end
  end

  # should replace this functionality with AddQuery/RemoveQuery actions
  def generate_next_url_newvar_from_hash(variablehash)
    uri = Addressable::URI.parse(request.fullpath.split('?')[0] + '?' + generate_next_url)
    newUri = uri.query_values.merge variablehash
    uri.query_values = newUri
    uri.query.to_s
  end

  # for the search form at the top of results
  # retains some of current search's fields (limiters)
  # discards pagenumber, facets and filters, actions, etc.
  def show_hidden_field_tags
    hidden_fields = ''
    params.each do |key, value|
      unless (key == 'search_field') || (key == 'fromDetail') || (key == 'facetfilter') || (key == 'pagenumber') || (key == 'q') || (key == 'dbid') || (key == 'an')
        if key == 'eds_action'
          hidden_fields << '<input type="hidden" name="' << key.to_s << '" value="' << value.to_s << '" />' if !value.scan(/addlimiter/).empty? || !value.scan(/removelimiter/).empty? || !value.scan(/setsort/).empty? || !value.scan(/SetResultsPerPage/).empty?
        elsif value.is_a?(Array)
          value.each do |arrayVal|
            hidden_fields << '<input type="hidden" name="' << key.to_s << '[]" value="' << arrayVal.to_s << '" />'
          end
        else
          hidden_fields << '<input type="hidden" name="' << key.to_s << '" value="' << value.to_s << '" />'
        end
      end
    end
    hidden_fields.html_safe
  end

  ###########
  # Pagination
  ###########

  # display how many results are being shown
  def show_results_per_page
    if params[:eds_action].present?
      unless params[:eds_action].to_s.scan(/SetResultsPerPage/).empty?
        rpp = params[:eds_action].to_s.gsub('SetResultsPerPage(', '').delete(')').to_i
        return rpp
      end
    end
    return params[:resultsperpage].to_i if params[:resultsperpage].present?
    20
  end

  # calculates total number of pages in results set
  def show_total_pages
    pages = show_total_hits / show_results_per_page
    pages + 1
  end

  # get current page, which serves as a base for most pagination functions
  def show_current_page
    if params[:eds_action].present?
      if !params[:eds_action].scan(/GoToPage/).empty?
        pagenum = params[:eds_action].to_s
        newpagenum = pagenum.gsub('GoToPage(', '')
        newpagenum = newpagenum.delete(')')
        return newpagenum.to_i
      elsif !params[:eds_action].scan(/SetResultsPerPage/).empty?
        if params[:pagenumber].present?
          return params[:pagenumber].to_i
        else
          return 1
        end
      else
        return 1
      end
    end
    return params[:pagenumber].to_i if params[:pagenumber].present?
    1
  end

  # display pagination at the top of the results list
  def show_compact_pagination
    previous_link = ''
    next_link = ''
    first_result_on_page_num = ((show_current_page - 1) * show_results_per_page) + 1
    last_result_on_page_num = first_result_on_page_num + show_results_per_page - 1
    last_result_on_page_num = show_total_hits if last_result_on_page_num > show_total_hits
    page_info = '<strong>' + first_result_on_page_num.to_s + '</strong> - <strong>' + last_result_on_page_num.to_s + '</strong> of <strong>' + show_total_hits.to_s + '</strong>'
    if show_current_page > 1
      previous_page = show_current_page - 1
      previous_link = '<a href="' + request.fullpath.split('?')[0] + '?' + generate_next_url + '&eds_action=GoToPage(' + previous_page.to_s + ')">&laquo; Previous</a> | '
    end
    if (show_current_page * show_results_per_page) < show_total_hits
      next_page = show_current_page + 1
      next_link = ' | <a href="' + request.fullpath.split('?')[0] + '?' + generate_next_url + '&eds_action=GoToPage(' + next_page.to_s + ')">Next &raquo;</a>'
    end
    compact_pagination = previous_link + page_info + next_link
    compact_pagination.html_safe
  end

  # bottom pagination.  commented out lines remove 'last page' link, as this is not currently supported by the API
  def show_pagination
    previous_link = ''
    next_link = ''
    page_num_links = ''

    if show_current_page > 1
      previous_page = show_current_page - 1
      previous_link = '<li class=""><a href="' + request.fullpath.split('?')[0] + '?' + generate_next_url + '&eds_action=GoToPage(' + previous_page.to_s + ')">&laquo; Previous</a></li>'
    else
      previous_link = '<li class="disabled"><a href="">&laquo; Previous</a></li>'
    end

    if (show_current_page * show_results_per_page) < show_total_hits
      next_page = show_current_page + 1
      next_link = '<li class=""><a href="' + request.fullpath.split('?')[0] + '?' + generate_next_url + '&eds_action=GoToPage(' + next_page.to_s + ')">Next &raquo;</a></li>'
    else
      next_link = '<li class="disabled"><a href="">Next &raquo;</a></li>'
    end

    page_num_links << '<li class=""><a href="' + request.fullpath.split('?')[0] + '?' + generate_next_url + '&eds_action=GoToPage(' + 1.to_s + ')">1</a></li>' if show_current_page >= 4
    page_num_links << '<li class="disabled"><a href="">...</a></li>' if show_current_page >= 5

    # show links to the two pages the the left and right (where applicable)
    bottom_page = show_current_page - 2
    bottom_page = 1 if bottom_page <= 0
    top_page = show_current_page + 2
    top_page = show_total_pages if top_page >= show_total_pages
    (bottom_page..top_page).each do |i|
      page_num_links << if i == show_current_page
                          '<li class="disabled"><a href="">' + i.to_s + '</a></li>'
                        else
                          '<li class=""><a href="' + request.fullpath.split('?')[0] + '?' + generate_next_url + '&eds_action=GoToPage(' + i.to_s + ')">' + i.to_s + '</a></li>'
                        end
    end

    page_num_links << '<li class="disabled"><a href="">...</a></li>' if show_total_pages >= (show_current_page + 3)

    pagination_links = previous_link + next_link + page_num_links
    pagination_links.html_safe
  end

  #############
  # Facet / Limiter Constraints Box
  #############

  # used when determining if the "constraints" partial should display
  def query_has_facetfilters?(_localized_params = params)
    !generate_next_url.scan('facetfilter[]=').empty? || !generate_next_url.scan('limiter[]=').empty?
  end

  # should probably return a hash and let the view handle the HTML
  def show_applied_facets
    appliedfacets = ''
    if session[:results]['SearchRequestGet']['SearchCriteriaWithActions']['FacetFiltersWithAction'].present?
      session[:results]['SearchRequestGet']['SearchCriteriaWithActions']['FacetFiltersWithAction'].each do |appliedfacet|
        appliedfacet.each do |key, val|
          next unless key == 'FacetValuesWithAction'
          val.each do |facetValue|
            appliedfacets << '<span class="appliedFilter constraint filter filter-format"><span class="filterName">' + facetValue['FacetValue']['Id'].to_s.gsub('EDS', '').titleize + '</span><span class="filterValue">' + facetValue['FacetValue']['Value'].to_s.titleize + '</span><a class="btnRemove imgReplace" href="' + request.fullpath.split('?')[0] + '?' + generate_next_url + '&eds_action=' + CGI.escape(facetValue['RemoveAction'].to_s) + '">Remove filter</a></span>'
          end
        end
      end
    end
    appliedfacets.html_safe
  end

  # should return hash and let the view handle the HTML
  def show_applied_limiters
    appliedlimiters = ''
    if session[:results].present?
      if session[:results]['SearchRequestGet']['SearchCriteriaWithActions'].present?
        if session[:results]['SearchRequestGet']['SearchCriteriaWithActions']['LimitersWithAction'].present?
          session[:results]['SearchRequestGet']['SearchCriteriaWithActions']['LimitersWithAction'].each do |appliedLimiter|
            limiterLabel = 'No Label'
            session[:info]['AvailableSearchCriteria']['AvailableLimiters'].each do |limiter|
              limiterLabel = limiter['Label'] if limiter['Id'] == appliedLimiter['Id']
            end
            if appliedLimiter['Id'] == 'DT1'
              appliedLimiter['LimiterValuesWithAction'].each do |limiterValues|
                appliedlimiters << '<span class="appliedFilter constraint filter filter-format"><span class="filterName">' + limiterLabel.to_s.titleize + '</span><span class="filterValue">' + limiterValues['Value'].gsub('-01/', ' to ').gsub('-12', '') + '</span><a class="btnRemove imgReplace" href="' + request.fullpath.split('?')[0] + '?' + generate_next_url + '&eds_action=' + appliedLimiter['RemoveAction'].to_s + '">Remove limiter</a></span>'
              end
            else
              appliedlimiters << '<span class="appliedFilter constraint filter filter-format"><span class="filterValue">' + limiterLabel.to_s.titleize + '</span><a class="btnRemove imgReplace" href="' + request.fullpath.split('?')[0] + '?' + generate_next_url + '&eds_action=' + appliedLimiter['RemoveAction'].to_s + '">Remove limiter</a></span>'
            end
          end
        end
      end
    end
    appliedlimiters.html_safe
  end

  #############
  # Facets / Limiters sidebar
  #############

  # check to see if result has any facets.  crude, and I forget why I had to do a length check..
  def has_eds_facets?
    (show_facets.length > 5)
  end

  def show_numlimiters
    get_info unless session[:numLimiters].present?
    session[:numLimiters]
  end

  # show limiters on the view
  def show_limiters
    limiterCount = 0
    limitershtml = ''
    get_info unless session[:info].present?
    if session[:info]['AvailableSearchCriteria']['AvailableLimiters'].present?
      limitershtml << '<form class="form"><ul style="margin-bottom:0px">'
      session[:info]['AvailableSearchCriteria']['AvailableLimiters'].each do |limiter|
        next unless limiter['Type'] == 'select'
        limiterChecked = false
        limiterAction = limiter['AddAction'].to_s.gsub('value', 'y')
        if session[:results].present?
          if session[:results]['SearchRequestGet']['SearchCriteriaWithActions'].present?
            if session[:results]['SearchRequestGet']['SearchCriteriaWithActions']['LimitersWithAction'].present?
              session[:results]['SearchRequestGet']['SearchCriteriaWithActions']['LimitersWithAction'].each do |appliedLimiter|
                if appliedLimiter['Id'] == limiter['Id']
                  limiterChecked = true
                  limiterAction = appliedLimiter['RemoveAction'].to_s
                end
              end
            end
          end
        end
        limitershtml << "<li style='font-size:small;'>"
        limitershtml << check_box_tag('limiters', limiterAction, limiterChecked, id: ('limiter-' + limiterCount.to_s), style: 'margin-top:-5px;')
        limitershtml << ' ' << limiter['Label'] << '</li>'
        limiterCount += 1
      end
      limitershtml << '</ul></form>'
      return limitershtml.html_safe
    else
      return session[:info].to_s
    end
  end

  def show_date_options
    dateString = ''
    timeObj = Time.new
    currentYear = timeObj.year
    fiveYearsPrior = currentYear - 5
    tenYearsPrior = currentYear - 10
    dateString << '<div class="facet_limit blacklight-date"><h5 class="twiddle">Publication Year<i class="icon-chevron"></i></h5><ul style="display: block;">'
    dateString << '<li><a href="' << request.fullpath.split('?')[0] << '?' << generate_next_url << '&eds_action=addlimiter(DT1:' << fiveYearsPrior.to_s << '-01/' << currentYear.to_s << '-12)">Last 5 Years</a></li>'
    dateString << '<li><a href="' << request.fullpath.split('?')[0] << '?' << generate_next_url << '&eds_action=addlimiter(DT1:' << tenYearsPrior.to_s << '-01/' << currentYear.to_s << '-12)">Last 10 Years</a></li>'
    dateString << '</ul></div>'
    dateString.html_safe
  end

  # show available facets
  def show_facets
    facets = ''
    if session[:results] && session[:results]['SearchResult'] && session[:results]['SearchResult']['AvailableFacets'].present?
      session[:results]['SearchResult']['AvailableFacets'].each do |facet|
        facets = facets + '<div class="facet_limit blacklight-' + facet['Id'] + '"><h5 class="twiddle">' + facet['Label'] + '<i class="icon-chevron"></i></h5><ul style="display: block;">'
        facet.each do |key, val|
          next unless key == 'AvailableFacetValues'
          val.each do |facetValue|
            facets = facets + '<li><a class="facet_select" href="' + request.fullpath.split('?')[0] + '?' + generate_next_url + '&eds_action=' + CGI.escape(facetValue['AddAction'].to_s) + '">' + facetValue['Value'].to_s.titleize + '</a> <span class="count">' + facetValue['Count'].to_s + '</li>'
          end
        end
        facets += '</ul></div>'
      end
    end
    facets.html_safe
  end

  #############
  # Sort / Display / Record Count
  #############

  # pull sort options from INFO method
  def show_sort_options
    sortDropdown = ''
    if session[:info]['AvailableSearchCriteria']['AvailableSorts'].present?
      session[:info]['AvailableSearchCriteria']['AvailableSorts'].each do |sortOption|
        sortDropdown << '<li><a href="' << request.fullpath.split('?')[0] + '?' + generate_next_url << '&eds_action=' << sortOption['AddAction'].to_s << '">' << sortOption['Label'].to_s << '</a></li>'
      end
    end
    sortDropdown.html_safe
  end

  # shows currently selected view
  def show_view_option
    uri = Addressable::URI.parse(request.fullpath.split('?')[0] + '?' + generate_next_url)
    newUri = uri.query_values
    view_option = if newUri['view'].present?
                    newUri['view'].to_s
                  else
                    'detailed'
                  end
    view_option
  end

  # shows currently selected sort
  def show_current_sort
    allsorts = ''
    if params[:eds_action].present?
      unless params[:eds_action].to_s.scan(/setsort/).empty?
        currentSort = params[:eds_action].to_s.gsub('setsort(', '').delete(')')
        if session[:info]['AvailableSearchCriteria']['AvailableSorts'].present?
          session[:info]['AvailableSearchCriteria']['AvailableSorts'].each do |sortOption|
            return 'Sort by ' << sortOption['Label'] if sortOption['Id'] == currentSort
          end
        end
      end
    end
    if params[:sort].present?
      if session[:info]['AvailableSearchCriteria']['AvailableSorts'].present?
        session[:info]['AvailableSearchCriteria']['AvailableSorts'].each do |sortOption|
          return 'Sort by ' << sortOption['Label'] if sortOption['Id'].to_s == params[:sort].to_s
        end
      end
    end
    'Sort by Relevance'
  end

  ###############
  # Results List
  ###############

  def has_restricted_access?(result)
    if result['Header']['AccessLevel'].present?
      return true if result['Header']['AccessLevel'] == '1'
    end
    false
  end

  def show_total_hits
    session[:results]['SearchResult']['Statistics']['TotalHits']
  end

  # see if title is available given a single result
  def has_titlesource?(result)
    if result['Items'].present?
      result['Items'].each do |item|
        return true if item['Group'].casecmp('src').zero?
      end
    end
    false
  end

  # display title given a single result
  def show_titlesource(result)
    source = ''
    flag = 0
    if result['Items'].present?
      result['Items'].each do |item|
        if item['Group'].casecmp('src').zero? && (flag == 0)
          source = processAPItags(item['Data'].to_s)
          flag = 1
        end
      end
    end
    source.html_safe
  end

  def has_subjects?(result)
    if result['RecordInfo'].present?
      if result['RecordInfo']['BibRecord'].present?
        if result['RecordInfo']['BibRecord']['BibEntity'].present?
          if result['RecordInfo']['BibRecord']['BibEntity']['Subjects'].present?
            return true if result['RecordInfo']['BibRecord']['BibEntity']['Subjects'].count > 0
          end
        end
      end
    end
    false
  end

  def show_subjects(result)
    # need to update this to look in granular data fields

    subject_array = []
    if result['RecordInfo'].present?
      if result['RecordInfo']['BibRecord'].present?
        if result['RecordInfo']['BibRecord']['BibEntity'].present?
          if result['RecordInfo']['BibRecord']['BibEntity']['Subjects'].present?
            result['RecordInfo']['BibRecord']['BibEntity']['Subjects'].each do |subject|
              next unless subject['SubjectFull']
              url_vars = { 'q' => '"' + subject['SubjectFull'].to_s + '"', 'search_field' => 'subject' }
              link2 = generate_next_url_newvar_from_hash(url_vars) << '&eds_action=GoToPage(1)'
              subject_link = if params[:dbid].present?
                               '<a href="' + request.fullpath.split('/' + params[:dbid])[0] + '?' + link2 + '">' + subject['SubjectFull'].to_s + '</a>'
                             else
                               '<a href="' + request.fullpath.split('?')[0] + '?' + link2 + '">' + subject['SubjectFull'].to_s + '</a>'
                             end
              subject_array.push(subject_link)
            end
          end
        end
      end
    end
    subject_string = ''
    subject_string = subject_array.join(', ')
    subject_string.html_safe
  end

  def has_pubdate?(result)
    if result['RecordInfo'].present?
      if result['RecordInfo']['BibRecord'].present?
        if result['RecordInfo']['BibRecord']['BibRelationships'].present?
          if result['RecordInfo']['BibRecord']['BibRelationships']['IsPartOfRelationships'].present?
            result['RecordInfo']['BibRecord']['BibRelationships']['IsPartOfRelationships'].each do |isPartOfRelationship|
              next unless isPartOfRelationship['BibEntity'].present?
              next unless isPartOfRelationship['BibEntity']['Dates'].present?
              isPartOfRelationship['BibEntity']['Dates'].each do |date|
                return true if date['Type'] == 'published'
              end
            end
          end
        end
      end
    end
    false
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
              next unless isPartOfRelationship['BibEntity'].present?
              next unless isPartOfRelationship['BibEntity']['Dates'].present?
              isPartOfRelationship['BibEntity']['Dates'].each do |date|
                next unless (date['Type'] == 'published') && (flag == 0)
                flag = 1
                if date['M'].present? && date['D'].present? && date['Y'].present?
                  pubdate << date['M'] << '/' << date['D'] << '/' << date['Y']
                elsif date['M'].present? && date['Y'].present?
                  pubdate << date['M'] << '/' << date['Y']
                elsif date['Y'].present?
                  pubdate << date['Y']
                else
                  pubdate << 'Not available.'
                end
              end
            end
          end
        end
      end
    end
    pubdate
  end

  def has_pubtype?(result)
    result['Header']['PubType'].present?
  end

  def show_pubtype(result)
    return result['Header']['PubType'] if has_pubtype?(result)
    ''
  end

  def has_pubtypeid?(result)
    result['Header']['PubTypeId'].present?
  end

  def show_pubtypeid(result)
    return result['Header']['PubTypeId'] if has_pubtypeid?(result)
    ''
  end

  def has_coverimage?(result)
    if result['ImageInfo'].present?
      result['ImageInfo'].each do |coverArt|
        return true if coverArt['Size'] == 'thumb'
      end
    end
    false
  end

  def show_coverimage_link(result)
    artUrl = ''
    flag = 0
    if result['ImageInfo'].present?
      result['ImageInfo'].each do |coverArt|
        if (coverArt['Size'] == 'thumb') && (flag == 0)
          artUrl << coverArt['Target']
          flag = 1
        end
      end
    end
    artUrl
  end

  def has_abstract?(result)
    if result['Items'].present?
      result['Items'].each do |item|
        next unless item['Group'].present?
        return true if item['Group'] == 'Ab'
      end
    end
    false
  end

  def show_abstract(result)
    abstractString = ''
    if result['Items'].present?
      result['Items'].each do |item|
        next unless item['Group'].present?
        abstractString << item['Data'] if item['Group'] == 'Ab'
      end
    end
    abstract = HTMLEntities.new.decode abstractString
    abstract.html_safe
  end

  def has_authors?(result)
    if result['Items'].present?
      result['Items'].each do |item|
        next unless item['Group'].present?
        return true if item['Group'] == 'Au'
      end
    end
    if result['RecordInfo'].present?
      if result['RecordInfo']['BibRecord'].present?
        if result['RecordInfo']['BibRecord']['BibRelationships'].present?
          if result['RecordInfo']['BibRecord']['BibRelationships']['HasContributorRelationships'].present?
            result['RecordInfo']['BibRecord']['BibRelationships']['HasContributorRelationships'].each do |contributor|
              return true if contributor['PersonEntity'].present?
            end
          end
        end
      end
    end
    false
  end

  # this should make use of AddQuery / RemoveQuery - but there might be a conflict with the "q" variable
  def show_authors(result)
    author_array = []
    if result['Items'].present?
      flag = 0
      authorString = []
      result['Items'].each do |item|
        next unless item['Group'].present?
        next unless item['Group'] == 'Au'
        # let Don and Michelle know what this cleaner function does
        newAuthor = processAPItags(item['Data'].to_s)
        # i'm duplicating the semicolor - fix
        newAuthor.gsub!('<br />', '; ')
        authorString.push(newAuthor)
        flag = 1
      end
      return authorString.join('; ').html_safe if flag == 1
    end

    if result['RecordInfo'].present?
      if result['RecordInfo']['BibRecord'].present?
        if result['RecordInfo']['BibRecord']['BibRelationships'].present?
          if result['RecordInfo']['BibRecord']['BibRelationships']['HasContributorRelationships'].present?
            result['RecordInfo']['BibRecord']['BibRelationships']['HasContributorRelationships'].each do |contributor|
              next unless contributor['PersonEntity'].present?
              next unless contributor['PersonEntity']['Name'].present?
              next unless contributor['PersonEntity']['Name']['NameFull'].present?
              url_vars = { 'q' => '"' + contributor['PersonEntity']['Name']['NameFull'].delete(',').gsub('%2C', '').to_s + '"', 'search_field' => 'author' }
              link2 = generate_next_url_newvar_from_hash(url_vars)
              author_link = '<a href="' + request.fullpath.split('?')[0] + '?' + link2 + '">' + contributor['PersonEntity']['Name']['NameFull'].to_s + '</a>'
              author_array.push(author_link)
            end
            return author_array.join('; ').html_safe
          end
        end
      end
    end
    ''
  end

  def show_resultid(result)
    result['ResultId'].to_s
  end

  def show_title(result)
    result['Items'].each do |item|
      return HTMLEntities.new.decode(item['Data']).html_safe if item['Group'] == 'Ti'
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
      return titles.join(' / ').html_safe
    end
    'Title not available.'
  end

  def show_results_array
    @results.inspect
  end

  def has_full_text_on_screen?(result)
    if result['FullText'].present?
      if result['FullText']['Text'].present?
        if result['FullText']['Text']['Availability'].present?
          return true if result['FullText']['Text']['Availability'] == '1'
        end
      end
    end
  end

  def show_full_text_on_screen(result)
    if result['FullText'].present?
      if result['FullText']['Text'].present?
        if result['FullText']['Text']['Availability'].present?
          HTMLEntities.new.decode(result['FullText']['Text']['Value']) if result['FullText']['Text']['Availability'] == '1'
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
    elsif has_smartlink?(result)
      return true
    elsif has_fulltext?(result)
      return true
    elsif has_ebook?(result)
      return true
    end
    false
  end

  def show_an(result)
    if result['Header'].present?
      an = result['Header']['An'].to_s if result['Header']['An'].present?
    end
    an
  end

  def show_dbid(result)
    if result['Header'].present?
      dbid = result['Header']['DbId'].to_s if result['Header']['DbId'].present?
    end
    dbid
  end

  def show_detail_link(result, resultId = '0', highlight = '')
    link = ''
    highlight.gsub! '&quot;', '%22'
    if result['Header'].present?
      if result['Header']['DbId'].present?
        if result['Header']['An'].present?
          link << 'articles/' << result['Header']['DbId'].to_s << '/' << url_encode(result['Header']['An']) << '/'
          if (resultId.to_i > '0'.to_i) && (highlight != '')
            link << '?resultId=' << resultId.to_s << '&highlight=' << highlight.to_s
          elsif resultId.to_i > '0'.to_i
            link << '?resultId=' << resultId.to_s
          elsif highlight != ''
            link << '?highlight' << highlight.to_s
          end
        end
      end
    end
    link
  end

  def show_best_fulltext_link(result)
    if has_pdf?(result)
      return show_pdf_title_link(result)
    elsif has_html?(result)
      return show_detail_link(result)
    elsif has_smartlink?(result)
      return show_smartlink_title_link(result)
    elsif has_fulltext?(result)
      return best_customlink(result)
    end
    ''
  end

  # generate full text link for the detailed record area (not the title link)
  def show_best_fulltext_link_detail(result)
    link = if has_pdf?(result)
             '<a href="' + show_pdf_title_link(result) + '">PDF Full Text</a>'
           elsif has_html?(result)
             '<a href="' + show_best_fulltext_link(result) + '" target="_blank">HTML Full Text</a>'
           elsif has_smartlink?(result)
             '<a href="' + show_smartlink_title_link(result) + '">Linked Full Text</a>'
           elsif has_fulltext?(result)
             best_customlink_detail(result)
           else
             ''
           end
    link.html_safe
  end

  def has_pdf?(result)
    if result['FullText'].present?
      if result['FullText']['Links'].present?
        result['FullText']['Links'].each do |link|
          return true if link['Type'] == 'pdflink'
        end
      end
    end
    false
  end

  def has_html?(result)
    if result['FullText'].present?
      if result['FullText']['Text'].present?
        if result['FullText']['Text']['Availability'].present?
          return true if result['FullText']['Text']['Availability'].to_s == '1'
        end
      end
    end
    false
  end

  def has_fulltext?(result)
    if result['FullText'].present?
      if result['FullText']['CustomLinks'].present?
        result['FullText']['CustomLinks'].each do |customLink|
          return true if customLink['Category'] == 'fullText'
        end
      end
    end
    false
  end

  def has_smartlink?(result)
    if result['FullText'].present?
      if result['FullText']['Links'].present?
        result['FullText']['Links'].each do |smartLink|
          return true if smartLink['Type'] == 'other'
        end
      end
    end
    false
  end

  def has_ebook?(result)
    if result['FullText'].present?
      if result['FullText']['Links'].present?
        result['FullText']['Links'].each do |smartLink|
          if smartLink['Type'] == 'ebook-pdf'
            return true
          elsif smartLink['Type'] == 'ebook-epub'
            return true
          end
        end
      end
    end
    false
  end

  def show_plink(result)
    plink = ''
    plink << result['PLink'] if result['PLink'].present?
    plink
  end

  def show_pdf_title_link(result)
    title_pdf_link = ''
    title_pdf_link << request.fullpath.split('?')[0] << '/' << result['Header']['DbId'].to_s << '/' << result['Header']['An'].to_s << '/fulltext' if result['Header']['DbId'].present? && result['Header']['An'].present?
    new_link = Addressable::URI.unencode(title_pdf_link.to_s)
    new_link
  end

  def show_smartlink_title_link(result)
    title_pdf_link = ''
    title_pdf_link << request.fullpath.split('?')[0] << '/' << result['Header']['DbId'].to_s << '/' << result['Header']['An'].to_s << '/fulltext' if result['Header']['DbId'].present? && result['Header']['An'].present?
    new_link = Addressable::URI.unencode(title_pdf_link.to_s)
    new_link
  end

  def show_ebook_title_link(result)
    title_pdf_link = ''
    title_pdf_link << request.fullpath.split('?')[0] << '/' << result['Header']['DbId'].to_s << '/' << result['Header']['An'].to_s << '/fulltext' if result['Header']['DbId'].present? && result['Header']['An'].present?
    new_link = Addressable::URI.unencode(title_pdf_link.to_s)
    new_link
  end

  def show_pdf_link(record)
    pdf_link = ''
    if record['FullText'].present?
      if record['FullText']['Links'].present?
        record['FullText']['Links'].each do |link|
          pdf_link << link['Url'] if link['Type'] == 'pdflink'
        end
      end
    end
    pdf_link
  end

  def show_smartlink(record)
    pdf_link = ''
    if record['FullText'].present?
      if record['FullText']['Links'].present?
        record['FullText']['Links'].each do |link|
          pdf_link << link['Url'] if link['Type'] == 'other'
        end
      end
    end
    pdf_link
  end

  def show_ebook_link(record)
    pdf_link = ''
    if record['FullText'].present?
      if record['FullText']['Links'].present?
        record['FullText']['Links'].each do |link|
          if link['Type'] == 'ebook-pdf'
            pdf_link << link['Url']
          elsif link['Type'] == 'ebook-epub'
            pdf_link << link['Url']
          end
        end
      end
    end
    pdf_link
  end

  def show_fulltext(result)
    fulltext_links = []
    if result['FullText'].present?
      if result['FullText']['CustomLinks'].present?
        result['FullText']['CustomLinks'].each do |customLink|
          if (customLink['Category'] == 'fullText') && customLink['Text'].present?
            fulltext_links << '<a href="' + customLink['Url'] + '">' + customLink['Text'] + '</a>'
          elsif customLink['Category'] == 'fullText'
            fulltext_links << '<a href="' + customLink['Url'] + '">Full Text via CustomLink' + customLink.to_s + '</a> '
          end
        end
      end
    end
    fulltext_links.join(', ').html_safe
  end

  # show prioritized custom links
  def best_customlink(result)
    fulltext_links = ''
    flag = 0
    if result['FullText'].present?
      if result['FullText']['CustomLinks'].present?
        result['FullText']['CustomLinks'].each do |customLink|
          if (customLink['Category'] == 'fullText') && (flag == 0)
            fulltext_links << customLink['Url']
            flag = 1
          end
        end
      end
    end
    fulltext_links
  end

  def best_customlink_detail(result)
    fulltext_links = ''
    flag = 0
    if result['FullText'].present?
      if result['FullText']['CustomLinks'].present?
        result['FullText']['CustomLinks'].each do |customLink|
          if (customLink['Category'] == 'fullText') && (flag == 0) && customLink['Text'].present? && customLink['Icon'].present?
            fulltext_links << '<a href="' + customLink['Url'] + '" target="_blank"><img src="' + customLink['Icon'] + '" border="0">' + customLink['Text'] + '</a>'
            flag = 1
          elsif (customLink['Category'] == 'fullText') && (flag == 0) && customLink['Text'].present?
            flag = 1
            fulltext_links << '<a href="' + customLink['Url'] + '" target="_blank">' + customLink['Text'] + '</a>'
          elsif (customLink['Category'] == 'fullText') && (flag == 0) && customLink['Icon'].present?
            fulltext_links << '<a href="' + customLink['Url'] + '" target="_blank"><img src="' + customLink['Icon'] + '" border="0"></a>'
            flag = 1
          elsif (customLink['Category'] == 'fullText') && (flag == 0)
            fulltext_links << '<a href="' + customLink['Url'] + '" target="_blank">Full Text via Custom Link</a>'
            flag = 1
          end
        end
      end
    end
    fulltext_links
  end

  def has_ill?(result)
    if result['CustomLinks'].present?
      result['CustomLinks'].each do |customLink|
        return true if customLink['Category'] == 'ill'
      end
    end
    false
  end

  def show_ill(result)
    fulltext_links = ''
    if result['CustomLinks'].present?
      result['CustomLinks'].each do |customLink|
        fulltext_links << '<a href="' << customLink['Url'] << '">Request via Interlibrary Loan</a> ' if customLink['Category'] == 'ill'
      end
    end
    fulltext_links.html_safe
  end

  ################
  # Debug Functions
  ################

  def show_query_string
    session[:results]['queryString']
  end

  def debugNotes
    # return session[:debugNotes] << "<h4>API Calls</h4>" << @connection.debug_notes
  end

  API_URL = 'http://eds-api.ebscohost.com/'
  API_URL_S = 'https://eds-api.ebscohost.com/'

  # Connection object. Does what it says. ConnectionHandler is what is usually desired and wraps auto-reonnect features, etc.
  class Connection
    attr_accessor :auth_token, :session_token, :debug_notes, :guest
    attr_writer :userid, :password

    # Init the object with userid and pass.
    def uid_init(userid, password, profile, guest = 'y')
      # @debug_notes = "<p>Setting guest as " << guest.to_s << "</p>"
      @userid = userid
      @password = password
      @profile = profile
      @guest = guest
      self
    end

    def ip_init(profile, guest = 'y')
      @profile = profile
      @guest = guest
      self
    end
    # Auth with the server. Currently only uid auth is supported.

    ###
    def uid_authenticate(_format = :xml)
      # DO NOT SEND CALL IF YOU HAVE A VALID AUTH TOKEN
      xml = "<UIDAuthRequestMessage xmlns='http://www.ebscohost.com/services/public/AuthService/Response/2012/06/01'><UserId>#{@userid}</UserId><Password>#{@password}</Password></UIDAuthRequestMessage>"
      uri = URI "#{API_URL_S}authservice/rest/uidauth"
      req = Net::HTTP::Post.new(uri.request_uri)
      req['Content-Type'] = 'application/xml'
      req['Accept'] = 'application/json' # if format == :json
      req.body = xml
      # @debug_notes << "<p>UID Authentication Call to " << uri.to_s << ": " << xml << "</p>";
      https = Net::HTTP.new(uri.hostname, uri.port)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE
      begin
        doc = JSON.parse(https.request(req).body)
      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
        about 'No response from server'
      end
      if doc.key?('ErrorNumber')
        abort "Bad response from server - error code #{result['ErrorNumber']}"
      else
        @auth_token = doc['AuthToken']
      end
    end

    def ip_authenticate(_format = :xml)
      uri = URI "#{API_URL_S}authservice/rest/ipauth"
      req = Net::HTTP::Post.new(uri.request_uri)
      req['Accept'] = 'application/json' # if format == :json
      https = Net::HTTP.new(uri.hostname, uri.port)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE
      begin
        doc = JSON.parse(https.request(req).body)
      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
        abort 'No response from server'
      end
      @auth_token = doc['AuthToken']
    end

    # Create the session
    def create_session
      uri = URI "#{API_URL}edsapi/rest/createsession?profile=#{@profile}&guest=#{@guest}"
      req = Net::HTTP::Get.new(uri.request_uri)
      # req['x-authenticationToken'] = @auth_token
      req['Accept'] = 'application/json'
      # @debug_notes << "<p>CREATE SESSION Call to " << uri.to_s << " with auth token: " << req['x-authenticationToken'].to_s << "</p>";
      #     Net::HTTP.start(uri.hostname, uri.port) { |http|
      #       doc = JSON.parse(http.request(req).body)
      #       return doc['SessionToken']
      #     }
      Net::HTTP.start(uri.hostname, uri.port) do |http|
        begin
        return http.request(req).body
      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
        abort 'No response from server'
      end
      end
    end

    # End the session
    def end_session(session_token)
      uri = URI "#{API_URL}edsapi/rest/endsession?sessiontoken=#{CGI.escape(session_token)}"
      req = Net::HTTP::Get.new(uri.request_uri)
      req['x-authenticationToken'] = @auth_token
      Net::HTTP.start(uri.hostname, uri.port) do |http|
        begin
        http.request(req)
      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
        abort 'No response from server'
      end
      end
      true
    end

    # Run a search query, XML results are returned
    def search(options, _format = :xml)
      uri = URI "#{API_URL}edsapi/rest/Search?#{options}"
      # return uri.request_uri
      req = Net::HTTP::Get.new(uri.request_uri)
      req['x-authenticationToken'] = @auth_token
      req['x-sessionToken'] = @session_token
      req['Accept'] = 'application/json' # if format == :json
      # @debug_notes << "<p>SEARCH Call to " << uri.to_s << " with auth token: " << req['x-authenticationToken'].to_s << " and session token: " << req['x-sessionToken'].to_s << "</p>";

      Net::HTTP.start(uri.hostname, uri.port) do |http|
        begin
        return http.request(req).body
      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
        abort 'No response from server'
      end
      end
    end

    # Retrieve specific information
    def retrieve(dbid, an, highlightterms = '', _format = :xml)
      uri = URI "#{API_URL}edsapi/rest/retrieve?dbid=#{dbid}&an=#{an}"
      uri = URI "#{API_URL}edsapi/rest/retrieve?dbid=#{dbid}&an=#{an}&highlightterms=#{highlightterms}" if highlightterms != ''
      req = Net::HTTP::Get.new(uri.request_uri)
      req['x-authenticationToken'] = @auth_token
      req['x-sessionToken'] = @session_token
      req['Accept'] = 'application/json' # if format == :json
      # @debug_notes << "<p>RETRIEVE Call to " << uri.to_s << " with auth token: " << req['x-authenticationToken'].to_s << " and session token: " << req['x-sessionToken'].to_s << "</p>";

      Net::HTTP.start(uri.hostname, uri.port) do |http|
        begin
        return http.request(req).body
      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
        abort 'No response from server'
      end
      end
    end

    # Info method
    def info(_format = :xml)
      uri = URI "#{API_URL}edsapi/rest/Info"
      req = Net::HTTP::Get.new(uri.request_uri)
      req['x-authenticationToken'] = @auth_token
      req['x-sessionToken'] = @session_token
      req['Accept'] = 'application/json' # if format == :json
      # @debug_notes << "<p>INFO Call to " << uri.to_s << " with auth token: " << req['x-authenticationToken'].to_s << " and session token: " << req['x-sessionToken'].to_s << "</p>";
      Net::HTTP.start(uri.hostname, uri.port) do |http|
        begin
        return http.request(req).body
      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
        abort 'No response from server'
      end
      end
    end
  end
  # Handles connections - retries failed connections, passes commands along
  class ConnectionHandler < Connection
    attr_accessor :max_retries
    attr_accessor :session_token
    def initialize(max_retries = 2)
      @max_retries = max_retries
    end

    def show_session_token
      @session_token
    end

    def show_auth_token
      @auth_token
    end

    # def create_session(auth_token = @auth_token, format = :xml)
    #   @auth_token = auth_token
    #     result = JSON.parse(super())
    #     if result.has_key?('ErrorNumber')
    #     return result.to_s
    #     else
    #     @session_token = result['SessionToken']
    #       return result['SessionToken']
    #     end
    # end
    def create_session(_format = :xml)
      # @auth_token = auth_token
      result = JSON.parse(super())
      @session_token = result['SessionToken']
    end

    def search(options, session_token, auth_token, format = :xml)
      attempts = 0
      @session_token = session_token
      @auth_token = auth_token
      loop do
        result = JSON.parse(super(options, format))
        if result.key?('ErrorNumber')
          # @debug_notes << "<p>Found ERROR " << result['ErrorNumber'].to_s
          case result['ErrorNumber']
          when '108'
            @session_token = create_session
            result = JSON.parse(super(options, format))
          when '109'
            @session_token = create_session
            result = JSON.parse(super(options, format))
          when '104'
            uid_authenticate(:json)
            result = JSON.parse(super(options, format))
          when '107'
            uid_authenticate(:json)
            result = JSON.parse(super(options, format))
          else
            return result
          end
          return result unless result.key?('ErrorNumber')
          attempts += 1
          return result if attempts >= @max_retries
        else
          return result
        end
      end
    end

    def info(session_token, auth_token, format = :xml)
      attempts = 0
      @auth_token = auth_token
      @session_token = session_token
      loop do
        result = JSON.parse(super(format)) # JSON Parse
        if result.key?('ErrorNumber')
          case result['ErrorNumber']
          when '108'
            @session_token = create_session
          when '109'
            @session_token = create_session
          when '104'
            uid_authenticate(:json)
          when '107'
            uid_authenticate(:json)
          end
          attempts += 1
          return result if attempts >= @max_retries
        else
          return result
        end
      end
    end

    def retrieve(dbid, an, highlightterms, session_token, auth_token, format = :xml)
      attempts = 0
      @session_token = session_token
      @auth_token = auth_token
      loop do
        result = JSON.parse(super(dbid, an, highlightterms, format))
        if result.key?('ErrorNumber')
          case result['ErrorNumber']
          when '108'
            @session_token = create_session
          when '109'
            @session_token = create_session
          when '104'
            uid_authenticate(:json)
          when '107'
            uid_authenticate(:json)
          end
          attempts += 1
          return result if attempts >= @max_retries
        else
          return result
        end
      end
    end
  end

  # Benchmark response times
  def benchmark(q = false)
    start = Time.now
    connection = ConnectionHandler.new(2)
    connection.uid_init('USERID', 'PASSWORD', 'PROFILEID')
    connection.uid_authenticate(:json)
    puts((start - Time.now).abs) unless q
    connection.create_session
    puts((start - Time.now).abs) unless q
    connection.search('query-1=AND,galapagos+hawk', :json)
    puts((start - Time.now).abs) unless q
    connection.end_session
    puts((start - Time.now).abs) unless q
  end

  # Run benchmark with warm up run; only if file was called directly and not required
  # if __FILE__ == $0
  #   benchmark(true)
  #   benchmark
  # end
end
