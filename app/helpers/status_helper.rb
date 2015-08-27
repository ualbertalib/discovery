require_relative "../services/symphony_service.rb"

module StatusHelper

  def status(bib_id, item_id)
    SymphonyService.new(bib_id).get_status(item_id)
  end

end
