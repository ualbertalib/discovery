# -*- encoding : utf-8 -*-
#
class EbooksController < CatalogController
  include Blacklight::Marc::Catalog
  include Blacklight::Catalog

  self.solr_search_params_logic << :show_only

  def show_only solr_parameters, user_parameters
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << 'source_tesim:"Symphony"'
    solr_parameters[:fq] << 'electronic_tesim:"Online"'
    #solr_parameters[:fq] << 'format:"Book"'
  end

  def index
    super
    @collection_name = "electronic books"
  end

end
