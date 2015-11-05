require_relative "../services/sfx_service.rb"
require_relative "../services/symphony_service.rb"
require_relative "../services/marc_module.rb"

module HoldingsHelper
  include MarcModule

  def holdings(document, method)
    doc = nokogiri document
    create_holdings_log = File.open("./log/holdings_create.log", "a")
    create_holdings_log.puts "doc.class=#{doc.class}"
    id = get_marc_id(doc)
    SymphonyService.new(id).send(method)
  end

  def fetch_sfx_holdings(document)
    SFXService.new(document).targets
  end

end
