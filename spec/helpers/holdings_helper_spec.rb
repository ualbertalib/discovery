require "spec_helper"

describe HoldingsHelper do
  describe "#display_ual_shield" do
    it "should display if #{I18n.t('ual_shield_UAL')}" do
      document = {"location_tesim" => I18n.t('ual_shield_UAL')}
      expect(helper.display_ual_shield(document)).to be true
    end

    it "should display if #{I18n.t('ual_shield_NEOS')}" do
      document = {"location_tesim" => I18n.t('ual_shield_NEOS')}
      expect(helper.display_ual_shield(document)).to be true
    end

    it "should not display if item is not available on campus" do
      document = {}
      expect(helper.display_ual_shield(document)).to be false
      document = {"location_tesim" => []}
      expect(helper.display_ual_shield(document)).to be false
    end
  end
end
