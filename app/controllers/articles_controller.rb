# -*- encoding : utf-8 -*-
require 'blacklight/catalog'

class ArticlesController < ApplicationController
  #before_filter :authenticate_user!

 include Blacklight::Catalog

end 
