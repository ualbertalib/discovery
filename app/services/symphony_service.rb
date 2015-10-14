class SymphonyService

  def initialize(id, xml_response=nil)
    if valid? id
      xml_response ||= open(ws_endpoint+ws_method+ws_parameters+id).read
      @document = Nokogiri::XML(xml_response)
    end
  end

  def items
    items = []
    for item in holdings_items do
      items << populate(item)
    end
    items
  end

  def get_summary_holdings(item_id)
     nodes.each do |node|
        current_node = node
        if label(current_node)
          if label(current_node).text == "Library has"
            return node_text(current_node)
          end
        end
      end
  end

  private

  def ws_endpoint
    "https://ws.library.ualberta.ca/symws3/rest/standard/"
  end

  def ws_method
    "lookupTitleInfo"
  end

  def ws_parameters
    "?clientID=Primo&marcEntryFilter=ALL&includeItemInfo=true&includeMarcHoldings=true&titleID="
  end

  def populate(item)
      item_id = id(item)
      call = get(".//xmlns:callNumber", item_id)
      status = get("currentLocationID", item_id)
      copies = get("numberOfCopies", item_id)
      type = get("itemTypeID", item_id)
      location = get("libraryID", item_id)
      {item_id: item_id, status: status, call: call, location: location, type: type, copies: copies}
  end

  def holdings_items
    @document.xpath("//xmlns:CallInfo")
  end

  def nodes
    @document.xpath("//xmlns:MarcEntryInfo", :xmlns=>"http://schemas.sirsidynix.com/symws/standard")
  end

  def label(current_node)
    current_node.at_xpath(".//xmlns:label", :xmlns=>"http://schemas.sirsidynix.com/symws/standard")
  end

  def node_text(current_node)
    current_node.at_xpath(".//xmlns:text", :xmlns=>"http://schemas.sirsidynix.com/symws/standard").text
  end

  def valid? id
    id.match /^[0-9]*$/
  end

  def id(item)
    item.at_xpath(".//xmlns:itemID", :xmlns=>"http://schemas.sirsidynix.com/symws/standard").text
  end

  def get(node, item_id)
      items = @document.xpath("//xmlns:ItemInfo", :xmlns=>"http://schemas.sirsidynix.com/symws/standard") if @document
      if items
        items.each do |item|
          if item.at_xpath(".//xmlns:itemID", :xmlns=>"http://schemas.sirsidynix.com/symws/standard").text == item_id
            return item.at_xpath(".//xmlns:#{node}", :xmlns=>"http://schemas.sirsidynix.com/symws/standard").text
          end
        end
      else
        return "NO_HOLDINGS_FOUND"
      end
    items
  end
end
