require_relative "../services/sfx_service.rb"
require_relative "../services/symphony_service.rb"
require_relative "../services/marc_module.rb"

module HoldingsHelper
  include MarcModule

  def holdings(document, method)
    doc = nokogiri document
    id = get_marc_id(doc)
    begin
      SymphonyService.new(id).send(method)
    rescue SymphonyService::Error::HTTPError => e
      logger.error e.message
      nil
    end
  end

  def fetch_sfx_holdings(document)
    begin
      SFXService.new(document).targets
    rescue SFXService::Error::HTTPError => e
      logger.error e.message
      nil
    end
  end

  def display_ual_shield(document)
    return false unless document["location_tesim"]
    return true if document["location_tesim"].include?(I18n.t('ual_shield_UAL'))
    return true if document["location_tesim"].include?(I18n.t('ual_shield_NEOS'))
    false
  end

end
