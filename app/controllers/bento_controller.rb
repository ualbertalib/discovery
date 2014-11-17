require "json"

class BentoController < ApplicationController

  def index
    @databases = []
    #@databases = DatabasesController.new.find.documents.first.as_json
    DatabasesController.new.find.documents.each do |db|
      @databases << db.as_json["title_display"]
    end
  end
end
