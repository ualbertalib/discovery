require_relative "../services/sfx_service.rb"

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
    SFXService.new(document).targets
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

  def populate_print_holdings(options = {})
    item = options[:item]
    items = options[:items]
    item_data = {}
    item_data[:call_number] = get_marc_subfield(item, 'a')
    item_data[:copies] = get_marc_subfield(item, 'c')
    item_data[:status] = get_marc_subfield(item, 'l')
    item_data[:location] = get_marc_subfield(item, 'm')
    items << item_data
  end

  def populate_links(options = {})
    items = options[:items]
    item = options[:item]
    type = options[:additional]
    url = get_marc_subfield(item, 'u')
    display = get_marc_subfield(item, '3')
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
      self.send options[:method].to_sym, {:items => items, :item => item, :additional => options[:additional_arg]}
    end
    items
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
end
