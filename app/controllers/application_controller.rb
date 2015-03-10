class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller 
   include Blacklight::Controller
  # Please be sure to impelement current_user and user_session. Blacklight depends on 
  # these methods in order to perform user specific actions. 

  layout 'blacklight'

  helper_method :load_lookup_tables

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    if session[:session_key].present?
      connection = EDSApi::ConnectionHandler.new(2)
      connection.end_session(session[:session_key])
      session[:session_key] = nil
    end
    if session[:results].present?
      session[:results] = nil
    end
    if session[:current_url].present?
      session[:current_url]
    end
  end

  def after_sign_out_path_for(resource)
    if session[:session_key].present?
      connection = EDSApi::ConnectionHandler.new(2)
      connection.end_session(session[:session_key])
      session[:session_key] = nil
    end
    if session[:results].present?
      session[:results] = nil
    end
    root_path
  end

  def load_lookup_tables
    @locations ||= YAML.load_file("config/locations.yml")
    @statuses ||= YAML.load_file("config/statuses.yml")
  end
end
