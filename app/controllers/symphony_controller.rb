# -*- encoding : utf-8 -*-
#
class SymphonyController < CatalogController
  include Blacklight::Marc::Catalog
  include Blacklight::Catalog

  self.solr_search_params_logic << :show_only_symphony

  def show_only_symphony solr_parameters, user_parameters
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << 'source:"Symphony"'
  end

end
