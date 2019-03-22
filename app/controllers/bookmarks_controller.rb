# -*- encoding : utf-8 -*-
class BookmarksController < CatalogController

  include Blacklight::Bookmarks

  def action_success_redirect_path
    bookmarks_path
  end
end
