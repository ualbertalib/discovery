require_relative "./ingester.rb"

class BatchIngest
  
  attr_writer :ingester, :root, :namespace

  def from_file(file, prefix, vocabulary)
    read file
    @records.each_with_index do |record, index|
      solr = vocabulary.from_xml(record.to_s).to_solr
      solr[:id] = "#{prefix}_#{index}"
      add solr
    end
  end

  def from_directory(dir, prefix, vocabulary)
    Dir.foreach(dir) do |file|
      next if file == "." or file == ".."
      path = "#{dir}/#{file}"
      from_file(path, prefix, vocabulary)
    end
  end

  def solr=(solr_url)
    @ingester.solr_object = RSolr.connect(solr_url)
  end

  private

  def read file
    @records = load_xml_from file
  end

  def add record
    @ingester.add_document(record)
  end

  def load_xml_from file
    Nokogiri::XML(File.open(file)).xpath(@root, @namespace)
  end
end
