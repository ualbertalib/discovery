module CatalogHelper
  include Blacklight::CatalogHelperBehavior

  def ual_electronic_access_label(location)
    loc = location.split(":").last.strip.gsub("University of Alberta Access", "").strip
    if loc.start_with?('(') && loc.end_with?(')') && loc.count('(') == 1 && loc.count(')') == 1
        loc=loc.delete('()').strip
    end
    return 'Click Here for University of Alberta Access' if loc.blank?
    return "Click Here for University of Alberta Access (#{loc})"
  end

  def ual_electronic_access_url(location,url)
    electronic_access_url(location.include?("Free Access"), url)
  end

  def database_electronic_access_url(document)
    electronic_access_url(document["enableproxy_tesim"].first == "1", document["url_tesim"].first)
  end

  def electronic_access_url(test,url)
    return url if test
    return Rails.application.config.proxy + url
  end
end
