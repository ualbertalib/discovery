require_relative "../services/symphony_service.rb"

module StatusHelper

  def status(bib_id, item_id, library)
    SymphonyService.new.get_status(bib_id, item_id, library)
  end

end
