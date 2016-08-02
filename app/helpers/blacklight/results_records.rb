
module Blacklight::Results_Records
  #############
  # Sort / Display / Record Count
  #############
	
  # pull sort options from INFO method
  def show_sort_options
    sortDropdown = "";
    if @info['AvailableSearchCriteria']['AvailableSorts'].present?
      @info['AvailableSearchCriteria']['AvailableSorts'].each do |sortOption|
        sortDropdown << '<li><a href="' << request.fullpath.split("?")[0] + "?" + generate_next_url << '&eds_action=' << sortOption["AddAction"].to_s << '">' << sortOption["Label"].to_s << '</a></li>'
      end
    end
    return sortDropdown.html_safe
  end

  # shows currently selected view
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

  # shows currently selected sort
  def show_current_sort
    allsorts = '';
    if params[:eds_action].present?
      if params[:eds_action].to_s.scan(/setsort/).length > 0
        currentSort = params[:eds_action].to_s.gsub("setsort(","").gsub(")","")
        if @info['AvailableSearchCriteria']['AvailableSorts'].present?
          @info['AvailableSearchCriteria']['AvailableSorts'].each do |sortOption|
            if sortOption['Id'] == currentSort
              return "Sort by " << sortOption["Label"]
            end
          end
        end              
      end
    end
    if params[:sort].present?
      if @info['AvailableSearchCriteria']['AvailableSorts'].present?
        @info['AvailableSearchCriteria']['AvailableSorts'].each do |sortOption|
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

  def has_restricted_access?(result)
    if result['Header']['AccessLevel'].present?
      if result['Header']['AccessLevel'] == '1'
        return true
      end
    end
    return false
  end

  def show_total_hits
    return @results.nil? ? 0 : @results['SearchResult']['Statistics']['TotalHits']
  end

  # see if title is available given a single result
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

  # display title given a single result
  def show_titlesource(result)
    source = ''
    flag = 0
    if result['Items'].present?
      result['Items'].each do |item|
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
    # need to update this to look in granular data fields

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

end
