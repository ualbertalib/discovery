require_relative "../spec_helper.rb"

# This needs to use a mock, not hit SFX directly.

include E

describe SymphonyService do

  let(:first_record){ File.open(E::*("fixtures/first_symphony_record.xml")).read }
  let(:second_record){ File.open(E::*("fixtures/second_symphony_record.xml")).read }
  let(:third_record){ File.open(E::*("fixtures/third_symphony_record.xml")).read }

  it "returns an item status" do
    s = SymphonyService.new("2661760", first_record)
    status = s.get_status("0162016585224")
    expect(status).to eq "CURRICULUM"
    s = SymphonyService.new("5843133", second_record)
    status = s.get_status("0162031173931")
    expect(status).to eq "CHECKEDOUT"
    s = SymphonyService.new("5ocn5843133", third_record)
    status = s.get_status("0162031173931")
    expect(status).to eq "NO_HOLDINGS_FOUND"
  end
end
