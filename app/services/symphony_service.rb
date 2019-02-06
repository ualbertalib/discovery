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
                Net::ProtocolError].freeze

  def initialize(id, xml_response = nil)
    raise Error::InvalidIdError unless valid? id

    begin
      xml_response ||= open(ws_endpoint + ws_method + ws_parameters + id, read_timeout: Rails.configuration.symphony_timeout).read
      @document = Nokogiri::XML(xml_response)
    rescue *EXCEPTIONS => e
      raise Error::HTTPError, 'SymphonyService: ' + e.message
    end
  end

  def items
    items = []
    if @document
      holdings_items.each do |item|
        if item.xpath('.//xmlns:ItemInfo').size == 1
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
    [ua, nonua]
  end

  private

  def summary_holdings
    nodes.each do |node|
      current_node = node
      next unless label(current_node)
      return node_text(current_node) if label(current_node).text == 'Library has'
    end
  end

  def ws_endpoint
    'https://ws.library.ualberta.ca/symws3/rest/standard/'
  end

  def ws_method
    'lookupTitleInfo'
  end

  def ws_parameters
    '?clientID=Primo&marcEntryFilter=ALL&includeItemInfo=true&includeAvailabilityInfo=true&includeMarcHoldings=true&titleID='
  end

  def populate(item)
    item_id = id(item)
    call = get(item, 'callNumber')
    status = get(item, 'currentLocationID')
    status == 'CHECKEDOUT' ? due = get(item, 'dueDate') : ''
    copies = get(item, 'numberOfCopies')
    type = get(item, 'itemTypeID')
    location = get(item, 'libraryID')
    public_note = get(item, 'publicNote')
    reserve_rule = get(item, 'reserveCirculationRule')
    { item_id: item_id,
      status: status,
      call: call,
      location: location,
      type: type,
      copies: copies,
      due: due,
      summary_holdings: summary_holdings,
      public_note: public_note,
      holdable: holdable, reserve_rule: reserve_rule }
  end

  def populate_subitems(item)
    subitems = []
    item.xpath('.//xmlns:ItemInfo').each do |subitem|
      item_id = id(subitem)
      call = get(item, 'callNumber')
      copies = get(item, 'numberOfCopies')
      location = get(item, 'libraryID')
      status = get(subitem, 'currentLocationID')
      status == 'CHECKEDOUT' ? due = get(subitem, 'dueDate') : ''
      type = get(subitem, 'itemTypeID')
      public_note = get(subitem, 'publicNote')
      reserve_rule = get(subitem, 'reserveCirculationRule')
      subitems << { item_id: item_id,
                    status: status,
                    call: call,
                    location: location,
                    type: type,
                    copies: copies,
                    due: due,
                    summary_holdings: summary_holdings,
                    public_note: public_note,
                    holdable: holdable,
                    reserve_rule: reserve_rule }
    end
    subitems
  end

  def populate_electronic_items
    ua_items = {}
    non_ua_items = {}
    if @document
      link_items.each do |item|
        if label(item) && (label(item).text == 'Electronic access') &&
           item.at_xpath('.//xmlns:text').present? && item.at_xpath('.//xmlns:url').present?
          if (item.at_xpath('.//xmlns:text').text.include? 'University of Alberta Access') ||
             (item.at_xpath('.//xmlns:text').text.include? 'Free') ||
             (item.at_xpath('.//xmlns:text').text.include? 'NEOS')
            ua_items[item.at_xpath('.//xmlns:text').text] = item.at_xpath('.//xmlns:url').text
          else
            non_ua_items[item.at_xpath('.//xmlns:text').text] = item.at_xpath('.//xmlns:url').text
          end
        end
      end
    end
    [ua_items, non_ua_items]
  end

  def holdings_items
    @document.xpath('//xmlns:CallInfo')
  end

  def link_items
    @document.xpath('//xmlns:MarcEntryInfo')
  end

  def holdable
    @document.xpath('//xmlns:holdable').text
  end

  def nodes
    @document.xpath('//xmlns:MarcEntryInfo', xmlns: 'http://schemas.sirsidynix.com/symws/standard')
  end

  def label(current_node)
    current_node.at_xpath('.//xmlns:label', xmlns: 'http://schemas.sirsidynix.com/symws/standard')
  end

  def node_text(current_node)
    current_node.at_xpath('.//xmlns:text', xmlns: 'http://schemas.sirsidynix.com/symws/standard').text
  end

  def valid?(id)
    (id =~ /^[0-9]*$/) == 0
  end

  def id(item)
    item.at_xpath('.//xmlns:itemID', xmlns: 'http://schemas.sirsidynix.com/symws/standard').text if item.at_xpath('.//xmlns:itemID', xmlns: 'http://schemas.sirsidynix.com/symws/standard')
  end

  def get(item, node)
    item.at_xpath(".//xmlns:#{node}", xmlns: 'http://schemas.sirsidynix.com/symws/standard').text if item.at_xpath(".//xmlns:#{node}", xmlns: 'http://schemas.sirsidynix.com/symws/standard')
  end
end
