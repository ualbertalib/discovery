require_relative "../spec_helper.rb"

# This needs to use a mock, not hit SFX directly.

describe SymphonyService do
  let(:first_record) do
    File.open(
      Rails.root.join('spec', 'fixtures', "first_symphony_record.xml")
    ).read
  end
  let(:second_record) do
    File.open(
      Rails.root.join('spec', 'fixtures', "second_symphony_record.xml")
    ).read
  end
  let(:third_record) do
    File.open(
      Rails.root.join('spec', 'fixtures', "third_symphony_record.xml")
    ).read
  end

  it "returns an item status" do
    s = SymphonyService.new("2661760", first_record).items
    expect(s.first[:status]).to eq "CURRICULUM"
    s = SymphonyService.new("5843133", second_record).items
    expect(s.first[:status]).to eq "CHECKEDOUT"
    expect { SymphonyService.new("5ocn5843133", third_record).items }.to raise_error SymphonyService::Error::InvalidIdError
  end

  it "returns a call number" do
    s = SymphonyService.new("2661760", first_record).items
    expect(s.first[:call]).to eq "QA 76.73 J38 S43 2000"
    s = SymphonyService.new("5843133", second_record).items
    expect(s.first[:call]).to eq "QA 76.73 C565 E538 2012"
  end

  it "returns a location" do
    s = SymphonyService.new("2661760", first_record).items
    expect(s.first[:location]).to eq "UAEDUC"
    s = SymphonyService.new("5843133", second_record).items
    expect(s.first[:location]).to eq "UASCITECH"
  end

  it "returns an item type" do
    s = SymphonyService.new("2661760", first_record).items
    expect(s.first[:type]).to eq "LOCAL_LOAN"
    s = SymphonyService.new("5843133", second_record).items
    expect(s.first[:type]).to eq "BOOK"
  end

  it "returns number of copies" do
    s = SymphonyService.new("2661760", first_record).items
    expect(s.first[:copies]).to eq "1"
    s = SymphonyService.new("5843133", second_record).items
    expect(s.first[:copies]).to eq "1"
  end

  it "returned a due date if checked out" do
    s = SymphonyService.new("2661760", first_record).items
    expect(s.first[:due]).to be_nil
    s = SymphonyService.new("5843133", second_record).items
    expect(s.first[:due]).to eq "2015-10-28T00:00:00-06:00"
  end

  it "returns a summary holdings statement" do
    # This doesn't mean anything, as neither of these is a journal
    s = SymphonyService.new("2661760", first_record).items
    expect(s.first[:summary_holdings]).to eq 0
    s = SymphonyService.new("5843133", second_record).items
    expect(s.first[:summary_holdings]).to eq 0
  end

  describe 'timeout handling' do
    before do
      allow(OpenURI).to receive(:open_uri) { raise Timeout::Error }
    end

    it { expect { SymphonyService.new("2661760") }.to raise_error SymphonyService::Error::HTTPError }
  end

  describe 'http error handling' do
    before do
      allow(OpenURI).to receive(:open_uri) { raise OpenURI::HTTPError.new('', nil) }
    end

    it { expect { SymphonyService.new("2661760") }.to raise_error SymphonyService::Error::HTTPError }
  end

  describe 'other error handling' do
    before do
      allow(OpenURI).to receive(:open_uri) { raise Exception }
    end

    it { expect { SymphonyService.new("2661760") }.to raise_error Exception }
  end

  it { expect { SymphonyService.new("invalid_id") }.to raise_error SymphonyService::Error::InvalidIdError }
end
