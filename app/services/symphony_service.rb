class SymphonyService

  def initialize
    @ws_endpoint = "https://ws.library.ualberta.ca/symws3/rest/standard/"
    @method = "lookupTitleInfo"
    @parameters = "?clientID=Primo&marcEntryFilter=ALL&includeAvailabilityInfo=true&titleID="
  end

  def get_status(id, library)
    url = @ws_endpoint+@method+@parameters+id+"&libraryFilter="+library
    document = Nokogiri::XML(open(url).read)
    document.xpath("//xmlns:locationOfFirstAvailableItem", :xmlns=>"http://schemas.sirsidynix.com/symws/standard").text
  end
end
