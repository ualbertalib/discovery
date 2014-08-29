require "rsolr"
require_relative "../spec_helper.rb"

describe "Metadata ingest pipeline" do

  context "when it is given a vocabulary object" do

    let(:ingester) { Ingester.new }
    dc = DublinCoreVocabulary.from_xml(File.open("../fixtures/dublin_core_record.xml"))

    it "should connect to the Solr instance" do
      rsolr = double # IRL pass an RSolr.connect object to the ingester
      ingester.solr_object = rsolr
      expect(rsolr).to receive(:add)
      expect(rsolr).to receive(:commit)
      ingester.add_document dc.to_solr
    end
  end
end
