require "rspec"
require "factory_girl"
require_relative "../lib/ingest/dublin_core_om"
require_relative "../lib/ingest/peel_mods_om"
require_relative "../lib/ingest/ingester"
require_relative "../lib/ingest/batch_ingest"

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

module E
  def *(path)
    File.expand_path(path, File.dirname(__FILE__))
  end
end
