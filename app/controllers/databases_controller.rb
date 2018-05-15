
# frozen_string_literal: true

class DatabasesController < CatalogController
  include Blacklight::Marc::Catalog
  include Blacklight::Catalog

  search_params_logic << :show_only

  def show_only(solr_parameters, _user_parameters)
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << 'format:"Database"'
  end

  def index
    super
    @collection_name = 'Databases'
  end
end
