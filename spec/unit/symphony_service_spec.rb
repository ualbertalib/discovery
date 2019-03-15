require_relative '../spec_helper.rb'

# This needs to use a mock, not hit SFX directly.

describe SymphonyService do
  let(:local_loan_curriculum) { VCR.use_cassette('local_loan_curriculum') { SymphonyService.new('2661760') } }
  let(:checked_out_book) { VCR.use_cassette('checked_out_book') { SymphonyService.new('5843133') } }
  let(:journal_with_holdings) { VCR.use_cassette('journal_with_holdings') { SymphonyService.new('8257854') } }
  let(:invalid_record) { VCR.use_cassette('invalid_record') { SymphonyService.new('5ocn5843133') } }

  it 'returns an item status' do
    expect(local_loan_curriculum.items.first[:status]).to eq 'CURR_HIST'
    expect(checked_out_book.items.first[:status]).to eq 'CHECKEDOUT'
    expect { invalid_record.items }.to raise_error SymphonyService::Error::InvalidIdError
  end

  it 'returns a call number' do
    expect(local_loan_curriculum.items.first[:call]).to eq 'QA 76.73 J38 S43 2000'
    expect(checked_out_book.items.first[:call]).to eq 'QA 76.73 C565 E538 2012'
  end

  it 'returns a location' do
    expect(local_loan_curriculum.items.first[:location]).to eq 'UAEDUC'
    expect(checked_out_book.items.first[:location]).to eq 'UASCITECH'
  end

  it 'returns an item type' do
    expect(local_loan_curriculum.items.first[:type]).to eq 'NO_LOAN'
    expect(checked_out_book.items.first[:type]).to eq 'BOOK'
  end

  it 'returns number of copies' do
    expect(local_loan_curriculum.items.first[:copies]).to eq '1'
    expect(checked_out_book.items.first[:copies]).to eq '1'
  end

  it 'returned a due date if checked out' do
    expect(local_loan_curriculum.items.first[:due]).to be_nil
    expect(checked_out_book.items.first[:due]).to eq '2019-05-31T00:00:00.035-06:00'
  end

  it 'returns a summary holdings statement' do
    expect(journal_with_holdings.items.first[:summary_holdings]).to eq '2018-'
    expect(local_loan_curriculum.items.first[:summary_holdings]).to be_nil
  end

  describe 'timeout handling' do
    before do
      allow(OpenURI).to receive(:open_uri) { raise Timeout::Error }
    end

    it { expect { local_loan_curriculum }.to raise_error SymphonyService::Error::HTTPError }
  end

  describe 'http error handling' do
    before do
      allow(OpenURI).to receive(:open_uri) { raise OpenURI::HTTPError.new('', nil) }
    end

    it { expect { local_loan_curriculum }.to raise_error SymphonyService::Error::HTTPError }
  end

  describe 'other error handling' do
    before do
      allow(OpenURI).to receive(:open_uri) { raise Exception }
    end

    it { expect { local_loan_curriculum }.to raise_error Exception }
  end

  it { expect { invalid_record }.to raise_error SymphonyService::Error::InvalidIdError }
end
