require 'rsolr'
require 'nokogiri'

if ARGV[0] then
  f=File.open(ARGV[0])
  doc=Nokogiri::XML(f)
  puts doc
  f.close

  puts "Updating..."
  rsolr = RSolr.connect :url => "http://0.0.0.0:8983/solr"
  rsolr.update :data => doc.to_s
  rsolr.commit
else
  puts "Usage: ruby post.rb <xmlfile>"
end

