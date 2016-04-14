# -*- encoding : utf-8 -*-
#
class NewBooksController < CatalogController
  include Blacklight::Marc::Catalog
  include Blacklight::Catalog
  
  self.solr_search_params_logic << :show_only

  def show_only solr_parameters, user_parameters
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << "id:(#{list_of_ids})"
  end

  def index
    super
    @collection_name = "New Books"
    render "new_books"
  end

  private

  def list_of_ids
    ids.join(" OR ")
  end

  def ids
    @ids ||= read_id_file
  end

  def read_id_file
    File.open("#{Rails.root}/data/new_books.txt").read.split("|\r\n").take 300
  end
end 
