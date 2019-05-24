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
    database_electronic_access? || @ua_urls.present? || @related_resources.present?
  end

  # These are 'On-campus access' and appear at the bottom of the page
  # for example catalog/6990969
  def electronic_access_bottom?
    !electronic_access_top? && @non_ua_urls.present?
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
    electronic_access_url(location.exclude?('Free Access'), url)
  end

  def database_electronic_access_url(document)
    electronic_access_url(document['enableproxy_tesim'].first == '1', document['url_tesim'].first)
  end

  def electronic_access_url(enableproxy, url)
    return url unless enableproxy

    Rails.application.config.proxy + url
  end

  # The original content from lgapi-ca.libapps.com is mangled during ingest to Solr
  # into a endline delimited single string with the keys removed and lots of whitespace.
  # This undoes that.
  # An array of icon hashes is returned.
  def libguides_icons(document)
    icons = []

    raw_icons = []
    raw_icons = document['icons_tesim'].first.split("\n").reject!(&:blank?) unless document['icons_tesim'].blank?

    raw_icons.each_slice(7) do |raw|
      raw = raw.map(&:strip)
      icon = { id: raw[0], site_id: raw[1], file: raw[2], description: raw[3], url: raw[4] }
      icons << icon
    end

    icons
  end

  def libguide_icon_image(icon)
    "https://libapps-ca.s3.amazonaws.com/sites/#{icon[:site_id]}/icons/#{icon[:id]}/#{icon[:file]}"
  end
end
