require_relative "../spec_helper.rb"

include E

describe Database do

  let(:database_csv){ File.open(E::*("fixtures/database_record.csv")).read }
  let(:db){ Database.new }
  let(:database_xml){ File.open(E::*("fixtures/database_record.xml")).read }

  it "should parse a single database record into a database object" do
    expect(db).to be_a_kind_of Database
  end

  it "should parse a database CSV object into a Ruby object" do
    db.parse(database_csv)
    expect(db.title).to eq "Web of Science Core Collection"
    expect(db.subject).to eq "Native Health"
    expect(db.primary_url).to eq "http://webofknowledge.com/WOS"
  end

  it "should return a basic xml represenation" do
    db.parse(database_csv)
    expect(db.to_xml).to eq database_xml.strip
  end
end
