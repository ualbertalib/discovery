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

  helper_method :load_lookup_tables

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def load_lookup_tables
    @locations ||= YAML.load_file("#{Rails.root}/config/locations.yml")
    @languages ||= YAML.load_file("#{Rails.root}/config/languages.yml")
    @statuses ||= YAML.load_file("#{Rails.root}/config/statuses.yml")
    @item_types ||= YAML.load_file("#{Rails.root}/config/item_types.yml")
    @circ_rules ||= YAML.load_file("#{Rails.root}/config/circ_rules.yml")
  end
end
