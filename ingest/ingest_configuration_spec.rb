require_relative "../spec_helper.rb"

include E

context "given a configuration YAML file" do

  let(:config_yaml){ YAML.load_file(E::*("fixtures/ingest.yml")) }
  let(:config){ IngestConfiguration.new("era", config_yaml) }

  it "should parse the file into the object fields" do
    expect(config.solr).to eq "http://localhost:8983/solr"
    expect(config.schema).to eq "dublin_core"
    expect(config.root).to eq "//xmlns:OAI-PMH"
    expect(config.delimiter).to eq "//xmlns:record"
    expect(config.namespace).to eq '{"xmlns" => "http://www.openarchives.org/OAI/2.0/"}'
    expect(config.endpoint).to eq "http://era.library.ualberta.ca/oaiprovider/?verb=ListRecords&metadataPrefix=oai_dc"
    expect(config.mode).to eq "file"
    expect(config.path).to eq "data/era.xml"
  end

  it "should return a class name from a vocabulary name" do
    expect(config.vocabulary).to be_a_kind_of Class
  end
end
