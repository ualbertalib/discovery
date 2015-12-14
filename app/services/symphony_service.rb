class SymphonyService
  module Error 
    class HTTPError < StandardError; end
    class InvalidIdError < StandardError; end
  end
  EXCEPTIONS = [Timeout::Error,
    Errno::EINVAL,
    EOFError,
    OpenURI::HTTPError,
    Net::HTTPBadResponse,
    Net::HTTPHeaderSyntaxError,
    Net::ProtocolError]

  def initialize(id, xml_response=nil)
    if valid? id
      begin
        xml_response ||= open(ws_endpoint+ws_method+ws_parameters+id, :read_timeout => Rails.configuration.symphony_timeout).read
        @document = Nokogiri::XML(xml_response)
      rescue *EXCEPTIONS => e
        raise Error::HTTPError, "SymphonyService: " + e.message
        @document = nil
      end
    else
      raise Error::InvalidIdError
      @document = nil
    end
  end

  def items
    items = []
    if @document then
      for item in holdings_items do
        if item.xpath(".//xmlns:ItemInfo").size == 1
          items << populate(item)
        else
          items.concat populate_subitems(item)
        end
      end
    end
    items
  end

  def links
    ua, nonua = populate_electronic_items
    return ua, nonua
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
    "?clientID=Primo&marcEntryFilter=ALL&includeItemInfo=true&includeAvailabilityInfo=true&includeMarcHoldings=true&titleID="
  end

  def populate(item)
      item_id = id(item)
      call = get(item, "callNumber")
      status = get(item, "currentLocationID")
      status == "CHECKEDOUT" ? due = get(item, "dueDate") : ""
      copies = get(item, "numberOfCopies")
      type = get(item, "itemTypeID")
      location = get(item, "libraryID")
      public_note = get(item, "publicNote")
      {item_id: item_id, status: status, call: call, location: location, type: type, copies: copies, due: due, summary_holdings: summary_holdings, public_note: public_note, holdable: holdable}
  end

  def populate_subitems(item)
    subitems = []
    item.xpath(".//xmlns:ItemInfo").each do |subitem|
      item_id = id(subitem)
      call = get(item, "callNumber")
      copies = get(item, "numberOfCopies")
      location = get(item, "libraryID")
      status = get(subitem, "currentLocationID")
      status == "CHECKEDOUT" ? due = get(subitem, "dueDate") : ""
      type = get(subitem, "itemTypeID")
      public_note = get(subitem, "publicNote")
      subitems << {item_id: item_id, status: status, call: call, location: location, type: type, copies: copies, due: due, summary_holdings: summary_holdings, public_note: public_note, holdable: holdable}
    end
    subitems
  end

  def populate_electronic_items
    ua_items = {}
    non_ua_items = {}
      if @document then
        link_items.each do |item|
          if label(item) and label(item).text == "Electronic access" then
            if (item.at_xpath(".//xmlns:text").text.include? "University of Alberta Access") or (item.at_xpath(".//xmlns:text").text.include? "Free") or (item.at_xpath(".//xmlns:text").text.include? "NEOS") then
                ua_items[item.at_xpath(".//xmlns:text").text] = item.at_xpath(".//xmlns:url").text
              else
                non_ua_items[item.at_xpath(".//xmlns:text").text] = item.at_xpath(".//xmlns:url").text
              end
          end
        end
      end
    return ua_items, non_ua_items
  end

  def holdings_items
    @document.xpath("//xmlns:CallInfo")
  end

  def link_items
    @document.xpath("//xmlns:MarcEntryInfo")
  end

  def holdable
    @document.xpath("//xmlns:holdable").text
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
    (id =~ /^[0-9]*$/) == 0
  end

  def id(item)
    if item.at_xpath(".//xmlns:itemID", :xmlns=>"http://schemas.sirsidynix.com/symws/standard")
      return item.at_xpath(".//xmlns:itemID", :xmlns=>"http://schemas.sirsidynix.com/symws/standard").text
    end
  end

  def get(item, node)
    if item.at_xpath(".//xmlns:#{node}", :xmlns=>"http://schemas.sirsidynix.com/symws/standard")
      return item.at_xpath(".//xmlns:#{node}", :xmlns=>"http://schemas.sirsidynix.com/symws/standard").text
    end
  end
end
