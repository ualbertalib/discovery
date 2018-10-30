class SymphonyController < CatalogController
  include Blacklight::Marc::Catalog
  include Blacklight::Catalog

  search_params_logic << :show_only

  def show_only(solr_parameters, _user_parameters)
    solr_parameters[:fq] ||= []
  end

  def index
    super
    @collection_name = ""
  end
end
