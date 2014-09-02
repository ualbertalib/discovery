desc 'fetch data file from the web'
# Syntax: 
# rake fetch 'http://era.library.ualberta.ca/oaiprovider/?verb=ListRecords&metadataPrefix=oai_dc|era.xml'
task :fetch do |t, args|
  url = ARGV.last.split("|").first
  filename = ARGV.last.split("|").last
  `wget "#{url}" -O #{Rails.root}/data/#{filename}`
  task ARGV.last.to_sym do ; end
end
