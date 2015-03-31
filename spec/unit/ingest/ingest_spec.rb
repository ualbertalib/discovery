require "rsolr"
require_relative "../../spec_helper.rb"

include E

describe "Metadata ingest pipeline" do

  context "when it is given a vocabulary object" do

    let(:ingester) { Ingester.new }
    let(:dc){ DublinCoreVocabulary.from_xml(File.open(E::*("fixtures/dublin_core_record.xml"))) }

    it "should connect to the Solr instance" do
      rsolr = double
      ingester.solr_object = rsolr
      expect(rsolr).to receive(:add)
      expect(rsolr).to receive(:commit)
      ingester.add_document dc.to_solr
    end
  end
end
