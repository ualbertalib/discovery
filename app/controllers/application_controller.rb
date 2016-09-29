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

    @results = nil if @results

    @current_url if @current_url
  end

  def after_sign_out_path_for(resource)
    if session[:session_key].present?
      connection = EDSApi::ConnectionHandler.new(2)
      connection.end_session(session[:session_key])
      session[:session_key] = nil
    end

    @results = nil if @results
    root_path
  end

  def load_lookup_tables
    @locations ||= YAML.load_file("#{Rails.root}/config/locations.yml")
    @languages ||= YAML.load_file("#{Rails.root}/config/languages.yml")
    @statuses ||= YAML.load_file("#{Rails.root}/config/statuses.yml")
    @item_types ||= YAML.load_file("#{Rails.root}/config/item_types.yml")
    @library_codes ||= YAML.load_file("#{Rails.root}/config/library_codes.yml")
    @circ_rules ||= YAML.load_file("#{Rails.root}/config/circ_rules.yml")
  end
end
