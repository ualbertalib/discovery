class SymphonyService

  def initialize(id)
    @ws_endpoint = "https://ws.library.ualberta.ca/symws3/rest/standard/"
    @method = "lookupTitleInfo"
    @parameters = "?clientID=Primo&marcEntryFilter=ALL&includeItemInfo=true&includeMarcHoldings=true&titleID="
    if valid? id
      xml_response = open(@ws_endpoint+@method+@parameters+id).read
      @document = Nokogiri::XML(xml_response)
    end
  end

  #needs refactoring!

  def get_status(item_id)
    get(".//xmlns:currentLocationID", item_id)
  end

  def get_item_type(item_id)
    get(".//xmlns:itemTypeID", item_id)
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
    nodes
  end

  private

  def valid? id
    id.match /^[0-9]*$/
  end

  def get(path, item_id)
      nodes = @document.xpath("//xmlns:ItemInfo", :xmlns=>"http://schemas.sirsidynix.com/symws/standard")
      nodes.each do |node|
        current_node = node
        if current_node.at_xpath(".//xmlns:itemID", :xmlns=>"http://schemas.sirsidynix.com/symws/standard").text == item_id
          return current_node.at_xpath(path, :xmlns=>"http://schemas.sirsidynix.com/symws/standard").text
        end
      end
    nodes
  end
end
