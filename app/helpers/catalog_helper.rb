module CatalogHelper
  include Blacklight::CatalogHelperBehavior

  def database_electronic_access?
    @document['format'].include?('Database') && @document['url_tesim'].present?
  end

  # These are typical electronic access links and appear at the top of the page
  # for example
  # (Database) catalog/11709037
  # (University of Alberta Access) catalog/2566934
  # (Finding Aid) catalog/4072071
  def electronic_access_top?
    database_electronic_access? || @ua_urls.present? || supplimentary_urls.present?
  end

  # These are 'On-campus access' and appear at the bottom of the page
  # for example catalog/6990969
  def electronic_access_bottom?
    !electronic_access_top? && @non_ua_urls
  end

  def eaccess_label(location)
    return 'Link:' if location.include?('http')
    location
  end

  def ual_electronic_access_label(location)
    loc = location.split(':').last.strip.gsub('University of Alberta Access', '').strip
    loc = loc.delete('()').strip if loc.start_with?('(') && loc.end_with?(')') && loc.count('(') == 1 && loc.count(')') == 1
    return 'Click Here for University of Alberta Access' if loc.blank?
    "Click Here for University of Alberta Access (#{loc})"
  end

  def ual_electronic_access_url(location, url)
    electronic_access_url(location.include?('Free Access'), url)
  end

  def database_electronic_access_url(document)
    electronic_access_url(document['enableproxy_tesim'].first == '1', document['url_tesim'].first)
  end

  def electronic_access_url(test, url)
    return url if test
    Rails.application.config.proxy + url
  end

  def supplimentary_urls
    urls = []
    urls = @document['summary_holdings_tesim'].zip(@document['url_suppl_display']) if @document['summary_holdings_tesim'] && @document['url_suppl_display']
    urls
  end
end
