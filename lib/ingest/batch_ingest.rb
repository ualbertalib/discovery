require_relative "./ingester.rb"

class BatchIngest
  
  attr_writer :ingester, :root, :namespace, :record_delimiter

  def from_file(file, vocabulary)
    read file
    @records.each_with_index do |record, index|
      solr = vocabulary.from_xml(record.to_s).to_solr
      puts solr
      solr[:id] = solr["id_tesim"]
      add solr if solr[:id]
    end
  end

  def from_directory(dir, vocabulary)
    Dir.foreach(dir) do |file|
      next if file == "." or file == ".."
      path = "#{dir}/#{file}"
      from_file(path, vocabulary)
    end
  end

  def solr=(solr_url)
    @ingester.solr_object = RSolr.connect(solr_url)
  end

  private

  def read file
    @records = []
    # Have to clean this up, //xmlns:record is for OAI DC records only
    Nokogiri::XML(File.open(file)).xpath(@root, @namespace).xpath(@record_delimiter).each{|record| @records << record }
  end

  def add record
    @ingester.add_document(record)
  end

  def load_xml_from file
    Nokogiri::XML(File.open(file)).xpath(@root, @namespace)

  end
end
