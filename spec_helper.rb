require "rspec"
require "yaml"
require "active_support/inflector"
require_relative "../lib/ingest/dublin_core_om"
require_relative "../lib/ingest/peel_mods_om"
require_relative "../lib/ingest/database"
require_relative "../lib/ingest/database_om"
require_relative "../lib/ingest/ingester"
require_relative "../lib/ingest/batch_ingest"
require_relative "../lib/tasks/ingest_configuration"

module E
  def *(path)
    File.expand_path(path, File.dirname(__FILE__))
  end
end
