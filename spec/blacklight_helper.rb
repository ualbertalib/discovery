ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require "rspec"
require "rspec-rails"
require "yaml"
require "active_support/inflector"
require "capybara/rspec"
require "capybara/rails"
require_relative "../lib/ingest/dublin_core_om"
require_relative "../lib/ingest/peel_mods_om"
require_relative "../lib/ingest/databases"
require_relative "../lib/ingest/database_om"
require_relative "../lib/ingest/promoted_services_om"
require_relative "../lib/ingest/ingester"
require_relative "../lib/ingest/batch_ingest"
require_relative "../lib/tasks/ingest_configuration"
require_relative "../app/helpers/holdings_helper.rb"
require_relative "../app/services/marc_module.rb"
require_relative "../app/services/sfx_service.rb"
require_relative "../app/services/symphony_service.rb"

module E
  def *(path)
    File.expand_path(path, File.dirname(__FILE__))
  end
end
