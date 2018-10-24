# -*- encoding : utf-8 -*-
#
class DatabasesController < CatalogController
  include Blacklight::Marc::Catalog
  include Blacklight::Catalog

  self.search_params_logic << :show_only

  def show_only solr_parameters, user_parameters
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << 'format:"Database"'
  end

  def index
    super
    @collection_name = "Databases"
  end
end
