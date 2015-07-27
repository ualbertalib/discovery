# -*- encoding : utf-8 -*-
#
class SymphonyController < CatalogController
  include Blacklight::Marc::Catalog
  include Blacklight::Catalog

  self.solr_search_params_logic << :show_only

  def show_only solr_parameters, user_parameters
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << 'source:"Symphony"'
    solr_parameters[:fq] << 'electronic_tesim:"Print"'
  end

  def index
    super
    @collection_name = "the library catalogue"
  end

end
