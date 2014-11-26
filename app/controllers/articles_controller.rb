# -*- encoding : utf-8 -*-
require 'blacklight/catalog'

class ArticlesController < CatalogController
  #before_filter :authenticate_user!

  include Blacklight::Catalog
  
end 
