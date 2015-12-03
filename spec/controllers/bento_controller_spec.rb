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
    # journals_count = assigns(:journals_count)
    # journals = assigns(:journals)
    # expect(journals_count).to eq 65
    # expect(journals.size).to eq journals_count
    # expect(journals.first).to be_a Array
    # expect(journals.first.first).to eq "1000163"
    # expect(journals.first[1]).to be_a Hash
    # expect(journals.first[1][:title]).to eq "Infection control and hospital epidemiology"
  end

  it "should populate symphony results" do
    # symphony_count = assigns(:symphony_count)
    # symphony = assigns(:symphony)
    # expect(symphony_count).to eq 10000
    # expect(symphony.size).to eq 100 # because a limit is set in the controller
    # expect(symphony.first).to be_a Array
    # expect(symphony.first.first).to eq "100000"
    # expect(symphony.first[1]).to be_a Hash
    # expect(symphony.first[1][:title]).to eq "All about winter safety"
  end

end
