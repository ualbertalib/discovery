require_relative "../rails_helper.rb"
require_relative "../rake_helper.rb"

describe BentoController, type: :controller do

  before(:each) do
    get :index
  end

  it "should load location table" do
    locations = assigns(:locations)
    expect(locations['aginternet']).to eq "Alberta Government Library Internet"
    expect(locations['uascitech']).to eq "University of Alberta Cameron Science & Technology"
  end

  it "should load status table" do
    statuses = assigns(:statuses)
    expect(statuses['trad_med']).to eq "traditional medicine"
    expect(statuses['sust_agric']).to eq "sustainable agriculture resource centre"
  end

  it "should populate database results" do
    database_count = assigns(:database_count)
    databases = assigns(:databases)
    expect(database_count).to eq 10
    expect(databases.size).to eq database_count
    expect(databases.first).to be_a Array
    expect(databases["11710064"].to_s).to eq '{:title=>"Advances in Polymer Science", :isbn=>nil, :issn=>nil, :year=>nil, :call_number=>nil, :format=>["Database"], :electronic=>["Online"]}'
    expect(databases["11710100"][:title]).to eq "America: History and Life with Full Text"
    expect(databases["11710328"][:title]).to eq "Canadiana"
  end

  it "should populate journal results" do
    journals_count = assigns(:journals_count)
    journals = assigns(:journals)
    expect(journals_count).to eq 65
    expect(journals.size).to eq journals_count
    expect(journals.first).to be_a Array
    expect(journals["1000163"].to_s).to eq '{:title=>"Infection control and hospital epidemiology", :isbn=>nil, :issn=>nil, :year=>["1988"], :call_number=>nil, :format=>["Serial"], :electronic=>["Online"]}'
    expect(journals["1000174"][:title]).to eq "Libraries & culture"
    expect(journals["954921332001"][:title]).to eq "Publishers weekly"
  end

  it "should populate symphony results" do
    symphony_count = assigns(:symphony_count)
    symphony = assigns(:symphony)
    expect(symphony_count).to eq 10000
    expect(symphony.size).to eq 100 # because a limit is set in the controller
    expect(symphony.first).to be_a Array
    expect(symphony["100000"].to_s).to eq  '{:title=>"All about winter safety", :isbn=>nil, :issn=>nil, :year=>["1975"], :call_number=>nil, :format=>["Book"], :electronic=>["At Library"]}'
    expect(symphony["1000000"][:title]).to eq "Wage and salary administration"
    expect(symphony["1000000"][:electronic].first).to eq "At Library"
    expect(symphony["1000010"][:title]).to eq "Enquête sur le salaire annuel garanti"
  end

  # figure out how to test for EDS results.

end


