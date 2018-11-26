module CatalogHelper
  include Blacklight::CatalogHelperBehavior

  def database_electronic_access_url(document)
    electronic_access_url(document["enableproxy_tesim"].first == "1", document["url_tesim"].first)
  end

  def electronic_access_url(test,url)
    return url if test
    return Rails.application.config.proxy + url
  end
end
