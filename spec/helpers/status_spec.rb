
require_relative "../spec_helper.rb"

include E
include StatusHelper

describe StatusHelper do

  describe "#fetch_symphony_status" do
    it "should get a live status from symphony web-services" do
      symphony_id = "5843133"
      library_id = "UASCITECH"
      item_id = "0162031173931" # because status belongs to an item
      expect(status(symphony_id, item_id, library_id)).to eq "ON_SHELF"
    end
  end

end
