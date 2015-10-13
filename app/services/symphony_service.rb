class SymphonyService

  def initialize(id, xml_response=nil)
    @ws_endpoint = "https://ws.library.ualberta.ca/symws3/rest/standard/"
    @method = "lookupTitleInfo"
    @parameters = "?clientID=Primo&marcEntryFilter=ALL&includeItemInfo=true&includeMarcHoldings=true&titleID="
    if valid? id
      xml_response ||= open(@ws_endpoint+@method+@parameters+id).read
      @document = Nokogiri::XML(xml_response)
    end
  end

  #needs refactoring!
  
  def items
    raw_items = @document.xpath("//xmlns:CallInfo")
    items = []
    for item in raw_items do
      item_id = item.at_xpath(".//xmlns:itemID", :xmlns=>"http://schemas.sirsidynix.com/symws/standard").text
      call = item.at_xpath(".//xmlns:callNumber", :xmlns=>"http://schemas.sirsidynix.com/symws/standard").text
      status = get_status(item_id)
      copies = item.at_xpath(".//xmlns:numberOfCopies", :xmlns=>"http://schemas.sirsidynix.com/symws/standard").text
      type = get_item_type(item_id)
      location = item.at_xpath(".//xmlns:libraryID", :xmlns=>"http://schemas.sirsidynix.com/symws/standard").text
      items << {item_id: item_id, status: status, call: call, location: location, type: type, copies: copies}
    end
    items
  end

  def get_status(item_id)
    get(".//xmlns:currentLocationID", item_id)
  end

  def get_item_type(item_id)
    get(".//xmlns:itemTypeID", item_id)
  end

  def get_call_number(item_id)
    get(".//xmlns:callNumber", item_id)
  end

  def get_location(item_id)
    get(".//xmlns:libraryID", item_id)
  end

  def get_summary_holdings(item_id)
      nodes = @document.xpath("//xmlns:MarcEntryInfo", :xmlns=>"http://schemas.sirsidynix.com/symws/standard")
      nodes.each do |node|
        current_node = node
        if current_node.at_xpath(".//xmlns:label", :xmlns=>"http://schemas.sirsidynix.com/symws/standard")
          if current_node.at_xpath(".//xmlns:label", :xmlns=>"http://schemas.sirsidynix.com/symws/standard").text == "Library has"
            return current_node.at_xpath(".//xmlns:text", :xmlns=>"http://schemas.sirsidynix.com/symws/standard").text
          end
        end
      end
  end

  private

  def valid? id
    id.match /^[0-9]*$/
  end

  def get(path, item_id)
      nodes = @document.xpath("//xmlns:ItemInfo", :xmlns=>"http://schemas.sirsidynix.com/symws/standard") if @document
      if nodes
        nodes.each do |node|
          current_node = node
          if current_node.at_xpath(".//xmlns:itemID", :xmlns=>"http://schemas.sirsidynix.com/symws/standard").text == item_id
            return current_node.at_xpath(path, :xmlns=>"http://schemas.sirsidynix.com/symws/standard").text
          end
        end
      else
        return "NO_HOLDINGS_FOUND"
      end
    nodes
  end
end
