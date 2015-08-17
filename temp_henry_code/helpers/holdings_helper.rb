require_relative "../services/sfx_service.rb"
require_relative "../services/symphony_service.rb"
require_relative "../services/marc_module.rb"

module HoldingsHelper
  include MarcModule

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

  def fetch_symphony_locations(document)
    locations = []
    doc = nokogiri document
    for item in marc_field(doc, '926') do
      locations << get_marc_subfield(item, 'm')
    end
    locations
  end

  private

  def populate_print_holdings(options = {})
#    f=open("./log/holding_populate.log","a")
    items = options[:items]
    item_data = {}
    id = options[:id]
    time1=Benchmark.realtime {
    item = options[:item]
    #items = options[:items]
    #item_data = {}
    item_data[:call_number] = get_marc_subfield(item, 'a')
    item_data[:item_id] = get_marc_subfield(item, 'i')
    item_data[:copies] = get_marc_subfield(item, 'c')
    item_data[:location] = get_marc_subfield(item, 'm')
    #symphony_response = SymphonyService.new(id)
    symphony_response = options[:symphony_response]
#    f.puts sprintf("symphony_response.class=%s",symphony_response.class)
    item_data[:status] = symphony_response.get_status(item_data[:item_id])
    item_data[:item_type] = symphony_response.get_item_type(item_data[:item_id])
    item_data[:summary_holdings] = symphony_response.get_summary_holdings(item_data[:item_id])
    }
#    f.puts sprintf("id=%s, time=%f",id,time1)
#    f.close()
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
      items << {url: url, display: display} if (display == "University of Alberta Access" or display.include? "Free Access")
    end
    if (type=="alternative")
      items << {url: url, display: display} if (display != "University of Alberta Access" and !display.include? "Free Access")
    end
  end

  def create_holdings(options = {})
    items = []
    doc = nokogiri options[:document]
#    f=open("./log/holdings_create.log","a")
#    f.puts sprintf("doc.class=%s",doc.class)
    id=get_marc_id(doc)
    symphony_response = SymphonyService.new(id)
    for item in marc_field(doc, options[:field]) do
#       f.puts sprintf("marc_id=%s, method=%s, item.class=%s, additional=%s, items.length=%d",id,options[:method], item.class, options[:additional_arg], items.length)
       #self.send options[:method].to_sym, {:id => get_marc_id(doc), :items => items, :item => item, :additional => options[:additional_arg]}
       self.send options[:method].to_sym, {:id => id, :items => items, :item => item, :additional => options[:additional_arg],:symphony_response=>symphony_response}
    end
#    f.close()
    items
  end

end
