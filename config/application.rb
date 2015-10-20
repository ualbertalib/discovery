require File.expand_path('../boot', __FILE__)

require 'rails/all'

require 'csv'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module VanillaBlacklight
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    @c = YAML.load_file('config/ingest.yml') rescue {}
    config.proxy = @c['proxy']
    config.solr = @c['solr']
    config.eager_load_paths += %W( #{Rails.root}/app/helpers/blacklight/articles_helper_behaviour )
    config.exceptions_app = self.routes
  end
end
