require_relative "./ingester.rb"

class BatchIngest
  
  attr_writer :ingester, :root, :namespace

  def from_file(file)
    read file
    @records.each do |record|
      add record
    end
  end

  def from_directory(dir)
    Dir.foreach(dir) do |file|
      next if file == "." or file == ".."
      path = "#{dir}/#{file}"
      from_file(path)
    end
  end

  private

  def read file
    @records =  load_xml_from file
  end

  def add record
    @ingester.add_document(record)
  end

  def load_xml_from file
    Nokogiri::XML(File.open(file)).xpath(@root, @namespace)
  end
end
