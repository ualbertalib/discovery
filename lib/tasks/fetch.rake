# frozen_string_literal: true

desc 'fetch data file from the web'
# Syntax:
# rake fetch 'http://era.library.ualberta.ca/oaiprovider/?verb=ListRecords&metadataPrefix=oai_dc|era.xml'
task :fetch, [:url] do |_t, args|
  url = args.url.split('|').first
  path = args.url.split('|').last
  `wget "#{url}" -O #{Rails.root}/#{path}`
end
