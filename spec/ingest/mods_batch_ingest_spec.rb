require_relative "../spec_helper.rb"

include E

describe "Batch Ingest Process" do

  let(:batch_ingester){ BatchIngest.new }
  let(:ingester){ instance_double(Ingester) }
  let(:root_element){ "//mods:modsCollection" }
  let(:record_delimiter){ "//mods:mods" }
  let(:namespace){ {"mods" => "http://www.loc.gov/mods/v3"} }

  before(:each) do
    batch_ingester.root = root_element
    batch_ingester.namespace = namespace
    batch_ingester.ingester = ingester
    batch_ingester.record_delimiter = record_delimiter
  end

  context "when it is provided with a collection of records in a single file" do
    it "should process and ingest every record in the file" do
      expect(ingester).to receive(:add_document).with(instance_of(Hash)).exactly(100).times
      batch_ingester.from_file(E::*("../data/curriculummods.xml"), CurriculumModsVocabulary)
    end
  end

end
