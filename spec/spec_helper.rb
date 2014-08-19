require "rspec"
require "factory_girl"
require_relative "../lib/ingest/dublin_core_om"

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
