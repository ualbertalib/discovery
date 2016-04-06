# -*- encoding : utf-8 -*-
#
class NewBooksController < CatalogController
  include Blacklight::Marc::Catalog
  include Blacklight::Catalog

  def index
    super
    @collection_name = "New Books"
    @document_list = []
    get_results(ids)
    render "new_books"
  end

  private

  def get_results(list_of_ids)

    for catkey in list_of_ids do
      (solr_response, document_list) = self.get_search_results(:q => "", :f => {id: "#{catkey}"}, :rows => 1)
      @document_list.concat document_list
    end

  end

  def ids
    @ids ||= read_id_file
  end

  def read_id_file
    File.open("#{Rails.root}/conf/new_books.txt").read.split("|\r\n").take 10
  end
end 
