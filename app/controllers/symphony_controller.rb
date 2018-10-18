# -*- encoding : utf-8 -*-
#
class SymphonyController < CatalogController
  include Blacklight::Marc::Catalog
  include Blacklight::Catalog

  self.search_params_logic << :show_only

  def show_only solr_parameters, user_parameters
    solr_parameters[:fq] ||= []

  end

  def index
    super
    @collection_name = ""
  end

end
