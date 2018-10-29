module ProfilesHelper
  def logged_in?
      !request.authorization.nil?
  end
end
