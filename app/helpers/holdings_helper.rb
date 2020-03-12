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
    @symphony_status ||= Hash.new do |h, key|
      status = Status.find_by(short_code: key) || begin
        Rollbar.error("Error retriving name for Status #{key}", e)
        Status.create(short_code: key, name: 'Unknown')
      end
      h[key] = status.name
    end
    @symphony_status[item[:status]]
  end

  def item_type(item)
    @item_type ||= Hash.new do |h, key|
      type = ItemType.find_by(short_code: key) || begin
        Rollbar.error("Error retriving name for ItemType #{key}", e)
        ItemType.create(short_code: key, name: 'Unknown')
      end
      h[key] = type.name
    end
    @item_type[item[:type]]
  end

  def reserve_rule(item)
    @reserve_rule ||= Hash.new do |h, key|
      rule = CirculationRule.find_by(short_code: key) || begin
        Rollbar.error("Error retriving name for CirculationRule #{key}", e)
        CirculationRule.create(short_code: key, name: 'Unknown')
      end
      h[key] = rule.name
    end
    @reserve_rule[item[:reserve_rule]]
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
    @location_name ||= Hash.new do |h, key|
      location = Location.includes(:library).find_by(short_code: key) || begin
        Rollbar.error("Error retriving name for Location #{key}", e)
        Location.create(
          short_code: key,
          name: 'Unknown'
        )
      end
      h[key] = location.name
    end
    @location_name[library_code]
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
