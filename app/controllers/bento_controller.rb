require "json"

class BentoController < ApplicationController

  def index
    @databases = populate_from DatabasesController
    @ejournals = populate_from EjournalsController
    @symphony = populate_from SymphonyController
  end

  private

  def populate_from(controller)
    documents = []
    controller.new.find.documents.each do |db|
      documents << db.as_json["title_display"]
    end
    documents
  end
end
