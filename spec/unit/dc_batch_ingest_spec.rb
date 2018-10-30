require_relative "../spec_helper.rb"

include E

describe "Batch Ingest Process" do
  let(:batch_ingester){ BatchIngest.new }
  let(:ingester){ instance_double(Ingester, :commit=>"", :add_document=>"") }
  let(:root_element){ "//xmlns:OAI-PMH" }
  let(:record_delimiter){ "//xmlns:record" }
  let(:namespace){ {"xmlns" => "http://www.openarchives.org/OAI/2.0/"} }

  before(:each) do
    batch_ingester.root = root_element
    batch_ingester.namespace = namespace
    batch_ingester.ingester = ingester
    batch_ingester.record_delimiter = record_delimiter
  end

  context "when it is provided with a collection of records in a single file" do
    it "should process and ingest every record in the file" do
      expect(ingester).to receive(:add_document).with(instance_of(Hash)).exactly(100).times
      batch_ingester.from_file(E::*("fixtures/collection.xml"), DublinCoreVocabulary)
    end
  end

  context "when it is provided with a collection of files in a directory" do
    it "should process and ingest every record in the directory" do
      expect(ingester).to receive(:add_document).exactly(100).times #.with(an_instance_of(Nokogiri::XML::Document))
      batch_ingester.from_directory(E::*("fixtures/collection"), DublinCoreVocabulary)
    end
  end
end
