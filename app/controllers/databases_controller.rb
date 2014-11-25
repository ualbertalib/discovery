# -*- encoding : utf-8 -*-
#
class DatabasesController < CatalogController
  include Blacklight::Marc::Catalog
  include Blacklight::Catalog

  self.solr_search_params_logic << :show_only_databases

  def show_only_databases solr_parameters, user_parameters
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << 'format:"Database"'
  end
end 
