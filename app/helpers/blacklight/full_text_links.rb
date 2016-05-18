
module Blacklight::Full_Text_Links
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
    highlight.gsub! '&quot;', '%22'
    if result['Header'].present?
      if result['Header']['DbId'].present?
        if result['Header']['An'].present?
          link << 'articles/' << result['Header']['DbId'].to_s << '/' << url_encode(result['Header']['An']) << '/'
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
      return show_detail_link(result)
    elsif has_smartlink?(result)
      return show_smartlink_title_link(result)
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
    elsif has_smartlink?(result)
      link = '<a href="' + show_smartlink_title_link(result) + '">Linked Full Text</a>'
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
  
  def has_smartlink?(result)
    if result['FullText'].present?
      if result['FullText']['Links'].present?
        result['FullText']['Links'].each do |smartLink|
          if smartLink['Type'] == "other"
            return true
          end
        end
      end
    end
    return false  
  end
  
  def has_ebook?(result)
    if result['FullText'].present?
      if result['FullText']['Links'].present?
        result['FullText']['Links'].each do |smartLink|
          if smartLink['Type'] == "ebook-pdf"
            return true
          elsif smartLink['Type'] == "ebook-epub"
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

  def show_smartlink_title_link(result)
    title_pdf_link = ''
    if result['Header']['DbId'].present? and result['Header']['An'].present?
      title_pdf_link << request.fullpath.split("?")[0] << "/" << result['Header']['DbId'].to_s << "/" << result['Header']['An'].to_s << "/fulltext"
    end
    new_link = Addressable::URI.unencode(title_pdf_link.to_s)
    return new_link    
  end

  def show_ebook_title_link(result)
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

  def show_smartlink(record)
    pdf_link = ''
    if record['FullText'].present?
      if record['FullText']['Links'].present?
        record['FullText']['Links'].each do |link|
          if link['Type'] == "other"
            pdf_link << link['Url']
          end
        end
      end
    end
    return pdf_link
  end

  def show_ebook_link(record)
    pdf_link = ''
    if record['FullText'].present?
      if record['FullText']['Links'].present?
        record['FullText']['Links'].each do |link|
          if link['Type'] == "ebook-pdf"
            pdf_link << link['Url']
          elsif link['Type'] == "ebook-epub"
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
end
