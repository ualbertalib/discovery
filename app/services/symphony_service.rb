class SymphonyService

  def initialize
    @ws_endpoint = "https://ws.library.ualberta.ca/symws3/rest/standard/"
    @method = "lookupTitleInfo"
    @parameters = "?clientID=Primo&marcEntryFilter=ALL&includeItemInfo=true&titleID="
  end

  def get_status(id, item_id, library)
    url = @ws_endpoint+@method+@parameters+id+"&libraryFilter="+library
    if valid? id
      document = Nokogiri::XML(open(url).read)
      nodes = document.xpath("//xmlns:ItemInfo", :xmlns=>"http://schemas.sirsidynix.com/symws/standard")
      nodes.each do |node|
        current_node = node
        if current_node.at_xpath(".//xmlns:itemID", :xmlns=>"http://schemas.sirsidynix.com/symws/standard").text == item_id
          return current_node.at_xpath(".//xmlns:currentLocationID", :xmlns=>"http://schemas.sirsidynix.com/symws/standard").text
        end
      end
    else
      nodes = "NO_HOLDINGS_FOUND"
    end
    nodes
  end

  private

  def valid? id
    id.match /^[0-9]*$/
  end
end
