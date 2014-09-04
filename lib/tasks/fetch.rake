desc 'fetch data file from the web'
# Syntax: 
# rake fetch 'http://era.library.ualberta.ca/oaiprovider/?verb=ListRecords&metadataPrefix=oai_dc|era.xml'
task :fetch, [:url] do |t, args|
  url = args.url.split("|").first
  filename = args.url.split("|").last
  `wget "#{url}" -O #{Rails.root}/data/#{filename}`
  #task args.last.to_sym do ; end
end
