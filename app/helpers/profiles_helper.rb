# frozen_string_literal: true

module ProfilesHelper
  def logged_in?
    !request.authorization.nil?
  end
end
