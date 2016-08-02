

module Blacklight::Facets_Limits
  #############
  # Facet / Limiter Constraints Box
  #############

  # used when determining if the "constraints" partial should display
  def query_has_facetfilters?(localized_params = params)
    (generate_next_url.scan("facetfilter[]=").length > 0) or (generate_next_url.scan("limiter[]=").length > 0)
  end

  # should probably return a hash and let the view handle the HTML
  def show_applied_facets
    appliedfacets = '';
    if @results['SearchRequestGet']['SearchCriteriaWithActions']['FacetFiltersWithAction'].present?
      @results['SearchRequestGet']['SearchCriteriaWithActions']['FacetFiltersWithAction'].each do |appliedfacet|
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
    if @results.present?
      if @results['SearchRequestGet']['SearchCriteriaWithActions'].present?
        if @results['SearchRequestGet']['SearchCriteriaWithActions']['LimitersWithAction'].present?
          @results['SearchRequestGet']['SearchCriteriaWithActions']['LimitersWithAction'].each do |appliedLimiter|
            limiterLabel = "No Label"
            @info['AvailableSearchCriteria']['AvailableLimiters'].each do |limiter|
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

  # check to see if result has any facets.  crude, and I forget why I had to do a length check..
  def has_eds_facets?
    (show_facets.length > 5)
  end

  def show_numlimiters
    unless session[:numLimiters].present?
      get_info
    end
    return session[:numLimiters]
  end

  # show limiters on the view
  def show_limiters
    limiterCount = 0;
    limitershtml = '';
    unless @info.present?
      get_info
    end
    if @info['AvailableSearchCriteria']['AvailableLimiters'].present?
      limitershtml << '<form class="form"><ul style="margin-bottom:0px">'
      @info['AvailableSearchCriteria']['AvailableLimiters'].each do |limiter|
        if limiter["Type"] == "select"
          limiterChecked = false
          limiterAction = limiter["AddAction"].to_s.gsub('value','y')
          if @results.present?
            if @results['SearchRequestGet']['SearchCriteriaWithActions'].present?
              if @results['SearchRequestGet']['SearchCriteriaWithActions']['LimitersWithAction'].present?
                @results['SearchRequestGet']['SearchCriteriaWithActions']['LimitersWithAction'].each do |appliedLimiter|
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
      return @info.to_s
    end
  end

  def show_date_options
    dateString = ""
    timeObj = Time.new
    currentYear = timeObj.year
    fiveYearsPrior = currentYear - 5
    tenYearsPrior = currentYear - 10
    dateString << '<div class="facet_limit blacklight-date"><h5 class="twiddle">Publication Year<i class="icon-chevron"></i></h5><ul style="display: block;">'
    dateString << '<li><a href="' << request.fullpath.split("?")[0] << "?" << generate_next_url << '&eds_action=addlimiter(DT1:' << fiveYearsPrior.to_s << '-01/' << currentYear.to_s << '-12)">Last 5 Years</a></li>'
    dateString << '<li><a href="' << request.fullpath.split("?")[0] << "?" << generate_next_url << '&eds_action=addlimiter(DT1:' << tenYearsPrior.to_s << '-01/' << currentYear.to_s << '-12)">Last 10 Years</a></li>'
    dateString << '</ul></div>'
    return dateString.html_safe
  end

  # show available facets
  def show_facets
    facets = '';
    if @results && @results['SearchResult'] && @results['SearchResult']['AvailableFacets'].present?
      @results['SearchResult']['AvailableFacets'].each do |facet|
        if facet['Label'] != "Collection"
          facets = facets + '<div class="facet_limit blacklight-' + facet['Id'] + '"><h5 class="twiddle">' + facet['Label'] + '<i class="icon-chevron"></i></h5><ul style="display: block;">'
          facet.each do |key, val|
            if key == "AvailableFacetValues"
              val.each do |facetValue|
                facets = facets + '<li><a class="facet_select" href="' + request.fullpath.split("?")[0] + "?" + generate_next_url + "&eds_action=" + CGI.escape(facetValue['AddAction'].to_s) + '">' + facetValue['Value'].to_s.titleize + '</a> <span class="count">' + facetValue['Count'].to_s + '</li>'
              end
            end
          end
          facets = facets + '</ul></div>'
        end
      end
    end
    return facets.html_safe
  end
end
