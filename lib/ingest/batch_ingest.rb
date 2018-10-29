require_relative "./ingester.rb"

class BatchIngest
  attr_writer :ingester, :root, :namespace, :record_delimiter

  def initialize
    @solr_url = Blacklight.connection_config[:url]
  end

  def from_file(file, vocabulary)
    read file
    @records.each_with_index do |record, index|
      solr = vocabulary.from_xml(record.to_s).to_solr
      next unless solr["id_tesim"]
      solr[:id] = solr["id_tesim"].first
      add solr if solr[:id]
    end
    @ingester.commit
  end

  def from_directory(dir, vocabulary)
    Dir.foreach(dir) do |file|
      next if [".", ".."].include? file
      path = "#{dir}/#{file}"
      from_file(path, vocabulary)
    end
  end

  def solr=(solr_url)
    @ingester.solr_object = RSolr.connect(solr_url, url: @solr_url)
  end

  private

  def read file
    @records = []
    Nokogiri::XML(File.open(file)).xpath(@root, @namespace).xpath(@record_delimiter).each{ |record| @records << record }
  end

  def add record
    @ingester.add_document(record)
  end
end
