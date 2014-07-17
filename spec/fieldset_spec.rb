require_relative "./spec_helper"

describe "creating a set of SOLR fields from an XML document" do
  context "when an single XML field is provided" do
    it "turns it into a SOLR field" do
      single_field = "<dc:creator>William Shakespeare</dc:creator>"
      field_set = FieldSet.new
      field_set.add single_field
      expect(field_set.size).to eq 1
      expect(field_set.first).to be_a SolrField
      expect(field_set.first.to_s).to eq %Q(<field name="dc:creator">William Shakespeare</field>)
    end
  end

  context "when multiple XML fields are provided" do
    it "adds multiple Solr fields to the fieldset" do
      multiple_fields = "<dc:creator>William Shakespeare</dc:creator><dc:title>The Merchant of Venice</dc:title><dc:year>1605</dc:year>"
      field_set = FieldSet.new
      field_set.add multiple_fields
      expect(field_set.size).to eq 3
      expect(field_set.first.to_s).to eq %Q(<field name="dc:creator">William Shakespeare</field>)
    end
  end

  # Currently only handles files with a single record
  context "when a full XML document is provided" do
    before(:all) do
      xml_document = %q[<?xml version="1.0" encoding="UTF-8"?><mods xmlns="http://www.loc.gov/mods/v3" version="3.3"><titleInfo><title>Geological map of the Province of Alberta, Canada</title></titleInfo><name type="personal"><namePart>Allan, John A.</namePart></name><name type="corporate"><namePart>Geological Survey Division, Scientific and Industrial Research Council of Alberta</namePart></name>].gsub("\n","")
      @field_set = FieldSet.new("//xmlns:mods")
      @field_set.add xml_document
    end

    it "adds the whole document to the fieldset" do
      expect(@field_set.size).to eq 3
      expect(@field_set.first.to_s).to eq %Q(<field name="title_titleInfo">Geological map of the Province of Alberta, Canada</field>)
      expect(@field_set[1].to_s).to eq %Q(<field name="personal_name">Allan, John A.</field>)
    end

    it "produces a solr xml record" do
      expect(@field_set.to_solr).to eq %Q(<?xml version=\"1.0\" encoding=\"UTF-8\"?><add><doc><field name=\"title_titleInfo\">Geological map of the Province of Alberta, Canada</field><field name=\"personal_name\">Allan, John A.</field><field name=\"corporate_name\">Geological Survey Division, Scientific and Industrial Research Council of Alberta</field></doc></add>)
    end
  end

  # context "when a Dublin Core document is provided" do
  #   it "produces a solr xml record" do
  #     xml_document = %q(<?xml version="1.0" encoding="UTF-8"?><OAI-PMH xmlns="http://www.openarchives.org/OAI/2.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd"><responseDate>2013-02-26T04:09:59Z</responseDate><request verb="ListRecords" metadataPrefix="oai_dc">http://era.library.ualberta.ca/oaiprovider/</request><ListRecords><record><header><identifier>oai:era.library.ualberta.ca:info:fedora/uuid:07732821-bf43-4a88-99cb-416b04fc0493</identifier><datestamp>2012-11-20T22:07:36Z</datestamp><setSpec>uuid:7af76c0f-61d6-4ebc-a2aa-79c125480269</setSpec></header><metadata><oai_dc:dc xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd"><dc:creator>Swallow, Mathew J B</dc:creator><dc:format>application/pdf</dc:format><dc:language>eng</dc:language><dc:subject>Boreal</dc:subject><dc:subject>Forest</dc:subject><dc:subject>bacteria</dc:subject><dc:subject>fungi</dc:subject><dc:subject>protist</dc:subject><dc:subject>soil</dc:subject><dc:subject>auxin</dc:subject><dc:title>The ecology of boreal forest floor microbial communities in relation to environmental factors</dc:title><dc:type>Thesis</dc:type><publisher>University of Alberta</publisher><rights>Permission is hereby granted to the University of Alberta Libraries to reproduce single copies of this thesis and to lend or sell such copies for private, scholarly or scientific research purposes only. Where the thesis is converted to, or otherwise made available in digital form, the University of Alberta will advise potential users of the thesis of these terms.The author reserves all other publication and other rights in association with the copyright in the thesis and, except as herein before provided, neither the thesis nor any substantial portion thereof may be printed or otherwise reproduced in any material form whatsoever without the author's prior written permission.</rights></oai_dc:dc></metadata></record></OAI-PMH>)
  #     @field_set = FieldSet.new("//xmlns:metadata")
  #     @field_set.add xml_document
  #     expect(@field_set.to_solr).to eq %Q(<?xml version=\"1.0\" encoding=\"UTF-8\"?><add><doc>")
  #   end
  # end

  context "when there are multiple instances of the same field" do
    describe "when the field name is simple" do
        it "should simply repeat the fields" do
	  repeated_fields = %Q(<subject>Ireland</subject><subject>Music</subject><subject>Tin Whistle</subject>)
	  field_set = FieldSet.new
	  field_set.add repeated_fields
	  expect(field_set.size).to eq 3
	  expect(field_set.first.to_s).to eq %Q(<field name="subject">Ireland</field>)
	  expect(field_set[1].to_s).to eq %Q(<field name="subject">Music</field>)
	  expect(field_set[2].to_s).to eq %Q(<field name="subject">Tin Whistle</field>)
      end
    end

    describe "when the field name is repeated with qualifiers" do
      it "should repeat the fields with qualified names" do
	  repeated_fields = %Q(<subject type="country">Ireland</subject><subject type="topic">Music</subject><subject type="instrument">Tin Whistle</subject>)
	  field_set = FieldSet.new
	  field_set.add repeated_fields
	  expect(field_set.size).to eq 3
	  expect(field_set.first.to_s).to eq %Q(<field name="country_subject">Ireland</field>)
	  expect(field_set[1].to_s).to eq %Q(<field name="topic_subject">Music</field>)
	  expect(field_set[2].to_s).to eq %Q(<field name="instrument_subject">Tin Whistle</field>)
      end
    end

    describe "when the field name is repeated with single-level nesting" do
      it "should repeat the fields with qualified names" do
	  repeated_fields = %Q(<subject><country>Ireland</country</subject><subject><topic>Music</topic></subject><subject><instrument>Tin Whistle</instrument></subject>)
	  field_set = FieldSet.new
	  field_set.add repeated_fields
	  expect(field_set.size).to eq 3
	  expect(field_set.first.to_s).to eq %Q(<field name="country_subject">Ireland</field>)
	  expect(field_set[1].to_s).to eq %Q(<field name="topic_subject">Music</field>)
	  expect(field_set[2].to_s).to eq %Q(<field name="instrument_subject">Tin Whistle</field>)
      end
   end

  describe "when the field name is repeated with multi-level nesting" do
    it "should repeat the fields with qualified names" do
      repeated_fields = %Q(<subject><country>Ireland</country><topic>Music</topic><instrument>Tin Whistle</instrument></subject>)
      field_set = FieldSet.new
      field_set.add repeated_fields
      expect(field_set.first.to_s).to eq %Q(<field name=\"country\">Ireland</field><field name=\"topic\">Music</field><field name=\"instrument\">Tin Whistle</field>)
   end
  end

  # describe "when the field text has HTML tags in it" do
  #   it "should strip them out" do
  #     single_field = "<dc:creator><b>William</b> <i>Shakespeare</i></dc:creator>"
  #     field_set = FieldSet.new
  #     field_set.add single_field
  #     expect(field_set.first.to_s).to eq %Q(<field name="dc:creator">William Shakespeare</field>)
  #   end
  # end

end
end
