require_relative "./spec_helper"

describe "the conversion of fields to SOLR fields" do
  context "when the field is simple" do
    it "should produce a single, correct SOLR field" do
      solr_field = SolrField.new('<dc:creator>William Shakespeare</dc:creator>')
      expect(solr_field.to_s).to eq '<field name="dc:creator">William Shakespeare</field>'
    end
  end

  context "when the field has a qualifier" do
    it "should produce a SOLR field with a compound name" do
      solr_field = SolrField.new('<name type="personal">William Shakespeare</name>')
      expect(solr_field.to_s).to eq '<field name="personal_name">William Shakespeare</field>'
    end
  end

  context "when the field is nested" do
    it "should produce a SOLR field with a compound name" do
      solr_field = SolrField.new('<subject><geographic>Ireland</geographic></subject>')
      expect(solr_field.to_s).to eq '<field name="geographic_subject">Ireland</field>'
    end
  end
end
