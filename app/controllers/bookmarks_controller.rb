# -*- encoding : utf-8 -*-
class BookmarksController < CatalogController

  include Blacklight::Bookmarks

  def index
    super
    load_lookup_tables
  end

end
