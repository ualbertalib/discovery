
# frozen_string_literal: true

class BookmarksController < CatalogController
  include Blacklight::Bookmarks

  def index
    super
    load_lookup_tables
  end
end
