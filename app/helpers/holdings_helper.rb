module HoldingsHelper
  
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
    targets = {}
    raw_targets(nokogiri document).each do |target|
      coverage = get_marc_subfield(target, 'a')
      targets[sfx_id(target)] = {id: sfx_id(target), coverage: coverage}
    end

    sfx_results_for(document.id).xpath("//target").each do |target|
      unless local_targets.include? name(target)        
        targets[id(target)].merge!({name: display_name(target), url: url(target) })
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
  
  def id(target)
    BigDecimal.new(target.xpath("target_service_id").text).to_i
  end

  def sfx_id(target)
    BigDecimal.new(get_marc_subfield(target, 's')).to_i  
  end

  def local_targets
    ["LOCAL_CATALOGUE_SIRSI_UNICORN", "MESSAGE_NO_DOCDEL_LCL"]
  end

  def name(target)
   target.xpath("target_name").text
  end

  def display_name(target)
   target.xpath("target_public_name").text
  end

  def url(target) 
    target.xpath("target_url").text
  end

  def raw_targets(doc)
    raw_targets = marc_field(doc, '866')
  end
end
