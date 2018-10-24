require "spec_helper"

describe SubjectHelper do
  describe "#subject_query" do
    it "should handle ampersands, periods and plus" do
      # https://github.com/ualbertalib/discovery/issues/910
      expect(helper.subject_query(['Library & Information Studies'])).to eq "\"Library  Information Studies\""

      expect(helper.subject_query(['England and Wales. Parliament'])).to eq "\"England and Wales Parliament\""
      expect(helper.subject_query(['C++ (Computer program language)'])).to eq "\"C   (Computer program language)\""
    end

    # https://github.com/ualbertalib/discovery/issues/1109
    it "should handle subject chaining" do
      expect(helper.subject_query(['Michif language ', ' Juvenile sound recordings'])).to eq "\"Michif language  Juvenile sound recordings\""
    end
  end
end
