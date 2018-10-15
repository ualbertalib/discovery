require "spec_helper"

describe HoldingsHelper do
  describe "#display_ual_shield" do
    UAL_SHIELD_LIBRARIES.each do |library|
      it "should display if #{library}" do
        document = {"location_tesim" => library}
        expect(helper.display_ual_shield(document)).to be true
      end
    end

    it "should not display if item is not available on campus" do
      document = {}
      expect(helper.display_ual_shield(document)).to be false
      document = {"location_tesim" => []}
      expect(helper.display_ual_shield(document)).to be false
    end
  end

  describe "#read_on_site_path" do
    it "should link to #{READ_ON_SITE_LOCATION_RCRF} form" do
      item = { location: READ_ON_SITE_LOCATION_RCRF }
      expect(helper.read_on_site_path(item)).to eq '/#TODO_RCRF'
    end

    it "should link to #{READ_ON_SITE_LOCATION_BPSC} form" do
      item = { location: READ_ON_SITE_LOCATION_BPSC }
      expect(helper.read_on_site_path(item)).to eq '/#TODO_BPSC'
    end

    it "should link somewhere else otherwise" do
      item = { location: 'SOMEWHERE' }
      expect(helper.read_on_site_path(item)).to eq errors_unprocessable_path
    end
  end
end
