require_relative "../spec_helper.rb"

include E

describe DublinCoreVocabulary do

  let(:dublin_core_document){ DublinCoreVocabulary.from_xml(File.open(E::*("fixtures/dublin_core_record.xml"))) }
  let(:solr_hash) { eval(File.open(E::*("fixtures/dc_solr_hash")).read) }

    it "should be a Dublin Core OM vocabulary with a terminology-based solrizer" do
      expect(dublin_core_document).to be_an_instance_of DublinCoreVocabulary
      expect(dublin_core_document).to be_a_kind_of OM::XML::Document
      expect(dublin_core_document).to be_a_kind_of OM::XML::TerminologyBasedSolrizer
    end

    it "should hold all the Dublin Core Core Elements" do
      expect(dublin_core_document.title).to eq ["The ecology of boreal forest floor microbial communities in relation to environmental factors"]
      expect(dublin_core_document.creator).to eq ["Swallow, Mathew J B"]
      expect(dublin_core_document.subject).to eq ["Boreal", "Forest", "bacteria", "fungi", "protist", "soil", "auxin"]
      expect(dublin_core_document.description).to eq ["Placeholder description - development only"]
      expect(dublin_core_document.publisher).to eq ["University of Alberta"]
      expect(dublin_core_document.contributors).to eq [] # test absent field
      expect(dublin_core_document.date).to eq ["1981/05/29"]
      expect(dublin_core_document.type).to eq ["Thesis"]
      expect(dublin_core_document.format).to eq ["application/pdf"]
      expect(dublin_core_document.identifier).to eq ["unicorn:843025"]
      expect(dublin_core_document.source).to eq ["OSS3441 - 35mm colour slide"]
      expect(dublin_core_document.language).to eq ["eng"]
      expect(dublin_core_document.relation).to eq ["Joel Martin Halpern Northern North America Collection"]
      expect(dublin_core_document.coverage).to eq ["Canada--Nunavut [NWT]--Igloolik"]
      expect(dublin_core_document.rights).to eq ["Rights statement"]
    end

    it "should hold fields for admin and technical metadata (non-DC)" do
      expect(dublin_core_document.oai_id).to eq ["oai:era.library.ualberta.ca:info:fedora/uuid:07732821-bf43-4a88-99cb-416b04fc0493"]
      expect(dublin_core_document.datestamp).to eq ["2012-11-20T22:07:36Z"]
      expect(dublin_core_document.spec).to eq ["uuid:7af76c0f-61d6-4ebc-a2aa-79c125480269"]
      expect(dublin_core_document.id).to eq dublin_core_document.spec
    end

    it "should have the fields tagged for Solr indexing" do
      expect(dublin_core_document.to_solr["title_tesim"]).to eq dublin_core_document.title
      expect(dublin_core_document.to_solr["creator_tesim"]).to eq dublin_core_document.creator
      expect(dublin_core_document.to_solr["subject_tesim"]).to eq dublin_core_document.subject
      expect(dublin_core_document.to_solr["description_tesim"]).to eq dublin_core_document.description
      expect(dublin_core_document.to_solr["publisher_tesim"]).to eq dublin_core_document.publisher
      expect(dublin_core_document.to_solr["contributors_tesim"]).to be_nil
      expect(dublin_core_document.to_solr["date_tesim"]).to eq dublin_core_document.date
      expect(dublin_core_document.to_solr["type_tesim"]).to eq dublin_core_document.type
      expect(dublin_core_document.to_solr["format_tesim"]).to eq dublin_core_document.format
      expect(dublin_core_document.to_solr["identifier_tesim"]).to eq dublin_core_document.identifier
      expect(dublin_core_document.to_solr["source_tesim"]).to eq dublin_core_document.source
      expect(dublin_core_document.to_solr["language_tesim"]).to eq dublin_core_document.language
      expect(dublin_core_document.to_solr["relation_tesim"]).to eq dublin_core_document.relation
      expect(dublin_core_document.to_solr["coverage_tesim"]).to eq dublin_core_document.coverage
      expect(dublin_core_document.to_solr["rights_tesim"]).to eq dublin_core_document.rights
      expect(dublin_core_document.to_solr["id_tesim"]).to eq dublin_core_document.id
      expect(dublin_core_document.to_solr["oai_id_tesim"]).to eq dublin_core_document.oai_id
      expect(dublin_core_document.to_solr["datestamp_tesim"]).to eq dublin_core_document.datestamp
      expect(dublin_core_document.to_solr["spec_tesim"]).to eq dublin_core_document.spec
    end

    describe "#to_solr" do
      it "should include Solr-tagged fields in a hash" do
        expect(dublin_core_document.to_solr).to eq solr_hash
      end
    end
end
