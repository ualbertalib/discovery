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

  def links
    populate_electronic_items
  end

  private

  def summary_holdings
     nodes.each do |node|
        current_node = node
        if label(current_node)
          if label(current_node).text == "Library has"
            return node_text(current_node)
          end
        end
      end
  end

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
      call = get(item, "callNumber")
      status = get(item, "currentLocationID")
      status == "CHECKEDOUT" ? due = get(item, "dueDate") : ""
      copies = get(item, "numberOfCopies")
      type = get(item, "itemTypeID")
      location = get(item, "libraryID")
      {item_id: item_id, status: status, call: call, location: location, type: type, copies: copies, due: due, summary_holdings: summary_holdings}
  end

  def populate_electronic_items
    items = {}
    
    link_items.each do |item|
      if label(item).text == "Electronic access" then
        items[item.at_xpath(".//xmlns:text").text] = item.at_xpath(".//xmlns:url").text
      end
    end
    items
  end

  def holdings_items
    @document.xpath("//xmlns:CallInfo")
  end

  def link_items
    @document.xpath("//xmlns:MarcEntryInfo")
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

  def get(item, node)
    item.at_xpath(".//xmlns:#{node}", :xmlns=>"http://schemas.sirsidynix.com/symws/standard").text
  end
end
