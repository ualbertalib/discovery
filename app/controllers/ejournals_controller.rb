# -*- encoding : utf-8 -*-
#
class EjournalsController < CatalogController
  include Blacklight::Marc::Catalog
  include Blacklight::Catalog

  self.solr_search_params_logic << :show_only_ejournals
  
  def show_only_ejournals solr_parameters, user_parameters
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << "source:SFX"
  end

end
