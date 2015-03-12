
require_relative "../spec_helper.rb"

include E
include StatusHelper

describe StatusHelper do

  describe "#fetch_symphony_status" do
    it "should get a live status from symphony web-services" do
      symphony_id = "45789"
      library_id = "UASCITECH"
      expect(status(symphony_id, library_id)).to eq "ON_SHELF"
    end
  end

end
