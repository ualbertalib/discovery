# -*- encoding : utf-8 -*-
#
class EjournalsController < CatalogController
  include Blacklight::Marc::Catalog
  include Blacklight::Catalog

  self.solr_search_params_logic << :show_only
  
  def show_only solr_parameters, user_parameters
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << "source:SFX"
  end

end
