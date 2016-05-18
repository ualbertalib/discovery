
module Blacklight::Pagination

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
        
  #bottom pagination.  commented out lines remove 'last page' link, as this is not currently supported by the API
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

    if show_total_pages >= (show_current_page + 3)
      page_num_links << '<li class="disabled"><a href="">...</a></li>'
    end

    pagination_links = previous_link + next_link + page_num_links
    return pagination_links.html_safe
  end
end
