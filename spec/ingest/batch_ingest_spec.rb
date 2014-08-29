require_relative "../spec_helper.rb"

describe "Batch Ingest Process" do

  let(:batch_ingester){ BatchIngest.new }
  let(:ingester){ instance_double(Ingester) }
  let(:root_element){ "//xmlns:record" }
  let(:namespace){ {"xmlns" => "http://www.openarchives.org/OAI/2.0/"} }

  before(:each) do
    batch_ingester.root = root_element
    batch_ingester.namespace = namespace
    batch_ingester.ingester = ingester
  end


  context "when it is provided with a collection of records in a single file" do
    it "should process and ingest every record in the file" do
      expect(ingester).to receive(:add_document).exactly(100).times #.with(an_instance_of(Nokogiri::XML::Document))
      batch_ingester.from_file("../fixtures/collection.xml")
    end
  end

  context "when it is provided with a collection of files in a directory" do
    it "should process and ingest every record in the directory" do
      expect(ingester).to receive(:add_document).exactly(100).times #.with(an_instance_of(Nokogiri::XML::Document))
      batch_ingester.from_directory("../fixtures/collection")
    end
  end
end
