require "rsolr"
require_relative "../spec_helper.rb"

include E

describe "Metadata ingest pipeline" do

  context "when it is given a vocabulary object" do

    let(:ingester) { Ingester.new }
    let(:dc){ DublinCoreVocabulary.from_xml(File.open(E::*("fixtures/dublin_core_record.xml"))) }

    it "should connect to the Solr instance" do
      rsolr = double("solr object", :commit => {"responseHeader"=>{"status" => 0, "QTime" => 5555}}, :add => {"responseHeader"=>{"status" => 0, "QTime" => 5555}})

      ingester.solr_object = rsolr
      expect(rsolr).to receive(:add)
      ingester.add_document dc.to_solr
      expect(rsolr).to receive(:commit)
      ingester.commit
    end
  end
end
