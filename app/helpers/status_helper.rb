require_relative "../services/symphony_service.rb"

module StatusHelper

  def status(id, library)
    SymphonyService.new.get_status(id, library)
  end

end
