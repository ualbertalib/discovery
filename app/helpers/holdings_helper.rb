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
    populate_holdings_log = File.open("./log/holding_populate.log", "a")
    items = options[:items]
    item_data = {}
    id = options[:id]
    time1 = Benchmark.realtime{
      item = options[:item]
      item_data[:call_number] = get_marc_subfield(item, 'a')
      item_data[:item_id] = get_marc_subfield(item, 'i')
      item_data[:copies] = get_marc_subfield(item, 'c')
      item_data[:location] = get_marc_subfield(item, 'm')
      symphony_response = options[:symphony_response]
      populate_holdings_log.puts "symphony_response.class=#{symphony_response.class}"
      items = symphony_response.items
      item_data[:status] = symphony_response.get_status(item_data[:item_id])
      item_data[:item_type] = symphony_response.get_item_type(item_data[:item_id])
      item_data[:summary_holdings] = symphony_response.get_summary_holdings(item_data[:item_id])
    }
    populate_holdings_log.puts "id=#{id}, time=#{time1}"
    populate_holdings_log.close
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
    create_holdings_log = File.open("./log/holdings_create.log", "a")
    create_holdings_log.puts "doc.class=#{doc.class}"
    id = get_marc_id(doc)
    symphony_response = SymphonyService.new(id)
    # for item in marc_field(doc, options[:field]) do
    #   create_holdings_log.puts "marc_id=#{id}, method=#{options[:method]}, item.class=#{item.class}, additional=#{options[:additional_arg]}, items.length=#{items.length}"
    #   self.send options[:method].to_sym, {:id => get_marc_id(doc), :items => items, :item => item, :additional => options[:additional_arg], :symphony_response=>symphony_response}
    # end
    symphony_response.items
  end

end
