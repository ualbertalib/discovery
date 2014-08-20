require "rspec"
require "factory_girl"
require_relative "../lib/ingest/dublin_core_om"
require_relative "../lib/ingest/peel_mods_om"
require_relative "../lib/ingest/ingester"

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
