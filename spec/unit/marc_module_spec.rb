require_relative "../spec_helper.rb"

include E

include MarcModule

describe MarcModule do

  let(:marc_record){ eval(File.open(E::*("fixtures/solr_document.rb")).read) }
  let(:nokogiri_doc){ nokogiri(marc_record) }

  it "should return a nokogiri document of a marc record" do
    expect(marc_record).to be_an_instance_of Hash
    expect(nokogiri(marc_record)).to be_an_instance_of Nokogiri::XML::Document
  end

  it "should return the value of a marc field" do
    expect(marc_field(nokogiri_doc, '245').text).to eq "Faith and ethics :recent Roman Catholicism /Vincent MacNamara."
    expect(marc_field(nokogiri_doc, '100').text).to eq "MacNamara, Vincent."
  end

  it "should return the value of a marc subfield" do
    # currently, this doesn't handle multiple marc fields well, but this
    # is all the functionality that is required at present
    expect(get_marc_subfield(marc_field(nokogiri_doc, '020'), 'z')).to eq "0878404264 (Georgetown University Press)"
    expect(get_marc_subfield(marc_field(nokogiri_doc, '260'), 'a')).to eq "Dublin :Washington, D.C. :"
    expect(get_marc_subfield(marc_field(nokogiri_doc, '260'), 'b')).to eq "Gill and Macmillan ;Georgetown University Press,"
  end
end
