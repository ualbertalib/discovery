class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  # Please be sure to impelement current_user and user_session. Blacklight depends on
  # these methods in order to perform user specific actions.

  # In jupiter setting Rails.application.routes.default_url_options was sufficient
  # but the rails documentation and experience suggests to set them here
  # https://guides.rubyonrails.org/action_controller_overview.html#default-url-options
  def default_url_options
    Rails.application.routes.default_url_options
  end

  layout 'blacklight'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
