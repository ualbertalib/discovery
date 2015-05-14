require "csv"
require_relative "../../spec_helper.rb"

include E

describe Database do

  let(:database_csv){ CSV.read(E::*("fixtures/database_record.csv")).first }
  let(:multi_database_csv){ CSV.read(E::*("fixtures/two_database_records.csv")) }
  let(:db){ Database.new }
  let(:database_xml){ File.open(E::*("fixtures/database_record.xml")).read }
  let(:multi_database_xml){ File.open(E::*("fixtures/two_database_records.xml")).read }

  it "should parse a single database record into a database object" do
    expect(db).to be_a_kind_of Database
  end

  it "should parse a database CSV object into a Ruby object" do
    db.parse(database_csv)
    expect(db.title).to eq "Web of Science Core Collection"
    expect(db.language).to eq "english"
    expect(db.primary_url).to eq "http://webofknowledge.com/WOS"
  end

  it "should return a basic xml represenation" do
    db.parse(database_csv)
    expect(db.to_xml).to eq database_xml.strip
  end

  it "should split a multi-record file into component records " do
    expect(multi_database_csv.first).to eq database_csv
    expect(db.parse(multi_database_csv.first)).to eq db.parse(database_csv)
    dbs = []
    multi_database_csv.each do |d|
      db.parse(d)
      dbs << db
    end
    db.parse(database_csv)
    expect(dbs.first.to_xml).to eq db.to_xml
    expect(dbs.size).to eq 2
    expect(dbs.first.to_xml).to eq database_xml.strip
  end

  it "should produce a correct, multi-record xml file" do
    dbs = Databases.new(E::*("fixtures/two_database_records.csv"))
    expect(dbs.xml_records.size).to eq 2
    expect(dbs.xml_file.gsub("\n", "").gsub('""', '"').gsub(">  <","><")).to eq multi_database_xml.gsub("\n", "").gsub('""', '"')

  end
end
