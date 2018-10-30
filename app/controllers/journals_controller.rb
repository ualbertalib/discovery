class JournalsController < CatalogController
  include Blacklight::Marc::Catalog
  include Blacklight::Catalog

  search_params_logic << :show_only

  def show_only(solr_parameters, _user_parameters)
    solr_parameters[:fq] ||= []
    # solr_parameters[:fq] << 'format: "Journal"'
    solr_parameters[:fq] << 'source: "SFX"'
  end

  def index
    super
    @collection_name = "e-Journals"
  end
end
