require_relative '../services/sfx_service.rb'
require_relative '../services/symphony_service.rb'
require_relative '../services/marc_module.rb'

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

  def symphony_status(item)
    Status.find_by!(short_code: item[:status].downcase.underscore).name
  rescue ActiveRecord::RecordNotFound => e
    Rollbar.error("Error retriving name for Status #{item[:status].downcase.underscore}", e)
    Status.create(short_code: item[:status].downcase.underscore, name: 'Unknown')
    'Unknown'
  end

  def item_type(item)
    ItemType.find_by!(short_code: item[:type].downcase.to_sym).name
  rescue ActiveRecord::RecordNotFound => e
    Rollbar.error("Error retriving name for ItemType #{item[:type].downcase.to_sym}", e)
    ItemType.create(short_code: item[:type].downcase.to_sym, name: 'Unknown')
    'Unknown'
  end

  def reserve_rule(item)
    CirculationRule.find_by!(short_code: item[:reserve_rule].to_sym).name
  rescue ActiveRecord::RecordNotFound => e
    Rollbar.error("Error retriving name for CirculationRule #{item[:reserve_rule].to_sym}", e)
    CirculationRule.create(short_code: item[:reserve_rule].to_sym, name: 'Unknown')
    'Unknown'
  end

  def fetch_sfx_holdings(document)
    SFXService.new(document).targets
  rescue SFXService::Error::HTTPError => e
    logger.error e.message
    nil
  end

  # determines whether or not ual shield should be displayed for the item
  def display_ual_shield(document)
    return false unless document['location_tesim']

    Location::UAL_SHIELD_LIBRARIES.detect { |library| document['location_tesim'].include? library }.present?
  end

  # TODO: If the way that libraries are identified changes this should follow that scheme
  READ_ON_SITE_LOCATION_RCRF = 'UARCRF'.freeze # Research and Collections Resource Facility
  READ_ON_SITE_LOCATION_BPSC = 'UASPCOLL'.freeze # Bruce Peel Special Collections

  def request_rcrf_read_on_site_form?(item)
    item[:location] == READ_ON_SITE_LOCATION_RCRF && item[:status] == 'READONSITE'
  end

  def request_bpsc_read_on_site_form?(item)
    item[:location] == READ_ON_SITE_LOCATION_BPSC && item[:status] == 'READONSITE'
  end

  def request_microform?(item)
    item[:location] == READ_ON_SITE_LOCATION_RCRF && item[:type] == 'MICROFORM'
  end

  # returns the library description that matches the code coming from symphony ws
  def library_location(library_code)
    Location.find_by!(short_code: library_code.downcase.delete('_').to_sym).name
  rescue ActiveRecord::RecordNotFound => e
    Rollbar.error("Error retriving name for Location #{library_code.downcase.delete('_').to_sym}", e)
    Location.create(
      short_code: library_code.downcase.delete('_').to_sym,
      name: 'Unknown'
    )
    'Unknown'
  end

  def kule_holdings(document, holdings)
    document[:call_number_status_tesim].each do |values|
      callnumber = values.split('|')
      item = {}
      item[:callnumber] = callnumber[0]
      item[:status] = case callnumber[1]
                      when 'NO_LOAN' then 'Read On Site'
                      else
                        callnumber[1]
                      end
      item[:access_title] = @document[:access_title_tesi]
      item[:access_url] = @document[:access_url_tesi]
      item[:location] = @document[:location_tesi]
      holdings << item
    end
    holdings
  end
end
