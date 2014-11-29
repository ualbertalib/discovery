module Holdings
  
  def create_ua_links(document)
     @urls = []
     @alternative_urls = []
     doc = Nokogiri::XML(document['marc_display']).remove_namespaces!
     links = doc.xpath("//datafield[@tag='856']")
     links.each do |link|
       url = link.xpath("subfield[@code='u']").text
       display = link.xpath("subfield[@code='3']").text
       if display == "University of Alberta Access"
         @urls << {url: url, display: display}      
       else
         @alternative_urls << {url: url, display: display}
       end
     end
  end

  def fetch_symphony_holdings(document)
    items = []
    doc = Nokogiri::XML(document['marc_display']).remove_namespaces!
    holdings = []
    holdings = doc.xpath("//datafield[@tag='926']")
    holdings.each do |item|
      item_data = {}
      item_data[:call_number] = item.xpath("subfield[@code='a']").text
      item_data[:copies] = item.xpath("subfield[@code='c']").text
      item_data[:status] = item.xpath("subfield[@code='l']").text
      item_data[:location] = item.xpath("subfield[@code='m']").text
      items << item_data
    end
    items
  end

  def fetch_sfx_holdings(document)
    doc = Nokogiri::XML(document['marc_display']).remove_namespaces!
    targets = {}
    raw_targets = doc.xpath("//datafield[@tag='866']")
    raw_targets.each do |target|
      coverage = target.xpath("subfield[@code='a']").text
      id = BigDecimal.new(target.xpath("subfield[@code='s']").text).to_i
      targets[id] = {id: id, coverage: coverage}
    end
    xml_response = Nokogiri::XML(open("http://resolver.library.ualberta.ca/resolver?ctx_enc=info%3Aofi%2Fenc%3AUTF-8&ctx_ver=Z39.88-2004&rfr_id=info%3Asid%2Fualberta.ca%3Aopac&rft.genre=journal&rft.object_id=#{document.id}&rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&url_ctx_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Actx&url_ver=Z39.88-2004&sfx.response_type=simplexml").read)
    xml_response.xpath("//target").each do |target|
      id = BigDecimal.new(target.xpath("target_service_id").text).to_i
      unless (target.xpath("target_name").text == "LOCAL_CATALOGUE_SIRSI_UNICORN") || (target.xpath("target_name").text == "MESSAGE_NO_DOCDEL_LCL")
        targets[id].merge!({name: target.xpath("target_public_name").text})
        targets[id].merge!({url: target.xpath("target_url").text})
      end
    end
    targets
  end
end
