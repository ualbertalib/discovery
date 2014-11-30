module Holdings
  
  def create_ua_links(document)
     create_holdings({document: document, field: '856', method: 'populate_links', additional_arg: "ua" })
  end

  def create_alternative_links(document)
     create_holdings({document: document, field: '856', method: 'populate_links', additional_arg: "alternative" })
  end

  def fetch_symphony_holdings(document)
    create_holdings({document: document, field: '926', method: 'populate_print_holdings' })
  end


  def fetch_sfx_holdings(document)
    doc = nokogiri document
    targets = {}
    raw_targets = marc_field(doc, '866')
    raw_targets.each do |target|
      coverage = get_marc_subfield(target, 'a')
      id = BigDecimal.new(get_marc_subfield(target, 's')).to_i # Very similar to id_of - must be some way to replace the two.
      targets[id] = {id: id, coverage: coverage}
    end

    xml_response = sfx_results_for(document.id)
    xml_response.xpath("//target").each do |target|
      id = id_of target 
      unless local_targets.include? target.xpath("target_name").text
        targets[id].merge!({name: target.xpath("target_public_name").text, url: target.xpath("target_url").text})
      end
    end
    targets
  end

  private

  def nokogiri(document)
    Nokogiri::XML(document['marc_display']).remove_namespaces!
  end

  def marc_field(document, tag)
    document.xpath("//datafield[@tag='#{tag}']")
  end

  def get_marc_subfield(document, tag)
    document.xpath("subfield[@code='#{tag}']").text
  end

  def populate_print_holdings items, item
    item_data = {}
    item_data[:call_number] = get_marc_subfield(item, 'a')
    item_data[:copies] = get_marc_subfield(item, 'c')
    item_data[:status] = get_marc_subfield(item, 'l')
    item_data[:location] = get_marc_subfield(item, 'm')
    items << item_data
  end
  
  def populate_links(items, link, type)
    url = get_marc_subfield(link, 'u')
    display = get_marc_subfield(link, '3')
    # I don't love this logic. Should be able to make it a single line.
    if (type=="ua")
      items << {url: url, display: display} if display == "University of Alberta Access"    
    end
    if (type=="alternative")
      items << {url: url, display: display} if display != "University of Alberta Access"
    end
  end
  
  def create_holdings(options = {})
    items = []
    doc = nokogiri options[:document]
    for item in marc_field(doc, options[:field]) do
      self.send options[:method].to_sym, items, item, options[:additional_arg]
    end
    items
  end

  def sfx_results_for(id)
    Nokogiri::XML(open("http://resolver.library.ualberta.ca/resolver?ctx_enc=info%3Aofi%2Fenc%3AUTF-8&ctx_ver=Z39.88-2004&rfr_id=info%3Asid%2Fualberta.ca%3Aopac&rft.genre=journal&rft.object_id=#{id}&rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&url_ctx_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Actx&url_ver=Z39.88-2004&sfx.response_type=simplexml").read)
  end
  
  def id_of(target, marc=nil)
    puts marc.nil?
    BigDecimal.new(target.xpath("target_service_id").text).to_i
  end
  
  def local_targets
    ["LOCAL_CATALOGUE_SIRSI_UNICORN", "MESSAGE_NO_DOCDEL_LCL"]
  end
end
