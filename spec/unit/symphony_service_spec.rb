require_relative "../spec_helper.rb"

# This needs to use a mock, not hit SFX directly.

include E

describe SymphonyService do
  it "returns an item status" do
    s = SymphonyService.new("2661760")
    status = s.get_status("0162016585224")
    expect(status).to eq "CURRICULUM"
    s = SymphonyService.new("5843133")
    status = s.get_status("0162031173931")
    expect(status).to eq "CHECKEDOUT"
    s = SymphonyService.new("5ocn5843133")
    status = s.get_status("0162031173931")
    expect(status).to eq "NO_HOLDINGS_FOUND"
  end
end
