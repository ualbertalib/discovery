require_relative "../../spec_helper.rb"

# This needs to use a mock, not hit SFX directly.

include E

describe SymphonyService do
  it "returns an item status" do
    status = SymphonyService.new.get_status("2661760", "0162016585224", "UAEDUC")
    expect(status).to eq "CURRICULUM"
    status = SymphonyService.new.get_status("5843133", "0162031173931", "UASCITECH")
    expect(status).to eq "ON_SHELF"
    status = SymphonyService.new.get_status("ocn5843133", "0162031173931", "UASCITECH")
    expect(status).to eq "NO_HOLDINGS_FOUND"
  end
end
