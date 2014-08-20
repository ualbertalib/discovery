require_relative "../spec_helper.rb"

describe PeelModsVocabulary do

  let(:mods_document){ PeelModsVocabulary.from_xml(File.open("../fixtures/mods_record.xml")) }

    it "should be a Dublin Core OM vocabulary with a terminology-based solrizer" do
      expect(mods_document).to be_an_instance_of PeelModsVocabulary
      expect(mods_document).to be_a_kind_of OM::XML::Document
      expect(mods_document).to be_a_kind_of OM::XML::TerminologyBasedSolrizer
    end


    it "should hold all the MODS elements" do
      expect(mods_document.abstract).to eq []
      expect(mods_document.accessCondition).to eq []
      expect(mods_document.affiliation).to eq []
      expect(mods_document.area).to eq []
      expect(mods_document.caption).to eq []
      expect(mods_document.cartographics).to eq ["w1200000/n0600000 w1100000/n0600000 w1100000/n0490000 w1200000/n05410xx1:1,900,800"]
      expect(mods_document.city).to eq []
      expect(mods_document.citySection).to eq []
      expect(mods_document.classification).to eq ["Alberta C-5:31"]
      expect(mods_document.continent).to eq []
      expect(mods_document.coordinates).to eq ["w1200000/n0600000 w1100000/n0600000 w1100000/n0490000 w1200000/n05410xx"]
      expect(mods_document.copyInformation).to eq []
      expect(mods_document.copyrightDate).to eq []
      expect(mods_document.county).to eq []
      expect(mods_document.country).to eq []
      expect(mods_document.date).to eq []
      expect(mods_document.dateCaptured).to eq []
      expect(mods_document.dateCreated).to eq []
      expect(mods_document.dateIssued).to eq ["1926"]
      expect(mods_document.dateModified).to eq []
      expect(mods_document.dateOther).to eq []
      expect(mods_document.description).to eq []
      expect(mods_document.descriptionStandard).to eq []
      expect(mods_document.detail).to eq []
      expect(mods_document.digitalOrigin).to eq []
      expect(mods_document.displayForm).to eq []
      expect(mods_document.edition).to eq []
      expect(mods_document.electronicLocator).to eq []
      expect(mods_document.end).to eq []
      expect(mods_document.enumerationAndChronology).to eq []
      expect(mods_document.etal).to eq []
      expect(mods_document.extension).to eq []
      expect(mods_document.extent).to eq ["1 map : blueline ; 66.5 x 37.3 cm. on sheet 73.7 x 44.1 cm."]
      expect(mods_document.form).to eq [""]
      expect(mods_document.frequency).to eq []
      expect(mods_document.marcgt_genre).to eq ["map"]
      expect(mods_document.genre).to eq ["geological map"]
      expect(mods_document.geographic).to eq ["Alberta"]
      expect(mods_document.geographicCode).to eq []
      expect(mods_document.hierarchicalGeographic).to eq []
      expect(mods_document.holdingExternal).to eq []
      expect(mods_document.holdingSimple).to eq []
      expect(mods_document.identifier).to eq ["257", "AAA-0302", "257.xml", "M000171", "N018785"]
      expect(mods_document.internetMediaType).to eq []
      expect(mods_document.island).to eq []
      expect(mods_document.issuance).to eq []
      expect(mods_document.language).to eq ["English"]
      expect(mods_document.languageOfCataloging).to eq []
      expect(mods_document.languageTerm).to eq ["English"]
      expect(mods_document.list).to eq []
      expect(mods_document.location).to eq ["UA Cameron Staff Access-Mapshttp://peel.library.ualberta.ca/maps/M/00/01/M000171/M000171.tif"]
      expect(mods_document.personalName).to eq ["Allan, John A."]
      expect(mods_document.corporateName).to eq ["Geological Survey Division, Scientific and Industrial Research Council of Alberta"]
      expect(mods_document.namePart).to eq  ["Allan, John A.", "Geological Survey Division, Scientific and Industrial Research Council of Alberta"]
      expect(mods_document.nonSort).to eq []
      expect(mods_document.note).to eq ["Taken from Geological Survey Division Map no. 10.", "Shadings differentiate kinds of tertiary, mesozoic, palaeozoic, and precambrian formations.", "peelmaps", "1", "73.7 x 44.1 cm.", "73.7", "44.1"]
      expect(mods_document.number).to eq []
      expect(mods_document.occupation).to eq []
      expect(mods_document.originInfo).to eq ["EdmontonScientific and Industrial Research Council of Alberta1926"]
      expect(mods_document.part).to eq []
      expect(mods_document.partName).to eq []
      expect(mods_document.partNumber).to eq []
      expect(mods_document.physicalDescription).to eq  ["1 map : blueline ; 66.5 x 37.3 cm. on sheet 73.7 x 44.1 cm."]
      expect(mods_document.place).to eq ["Edmonton"]
      expect(mods_document.placeTerm).to eq ["Edmonton"]
      expect(mods_document.projection).to eq []
      expect(mods_document.province).to eq []
      expect(mods_document.publisher).to eq ["Scientific and Industrial Research Council of Alberta"]
      expect(mods_document.recordChangeDate).to eq ["2010-11-23T11:51:29-0700"]
      expect(mods_document.recordCreationDate).to eq []
      expect(mods_document.recordContentSource).to eq ["mapsproject", "sfarnel"]
      expect(mods_document.recordIdentifier).to eq ["N018785"]
      expect(mods_document.recordInfo).to eq ["mapsprojectsfarnelN0187852010-11-23T11:51:29-0700"]
      expect(mods_document.recordOrigin).to eq []
      expect(mods_document.reformattingQuality).to eq []
      expect(mods_document.region).to eq []
      expect(mods_document.relatedItem).to eq []
      expect(mods_document.role).to eq []
      expect(mods_document.roleTerm).to eq []
      expect(mods_document.scale).to eq ["1:1,900,800"]
      expect(mods_document.shelfLocator).to eq []
      expect(mods_document.start).to eq []
      expect(mods_document.state).to eq []
      expect(mods_document.subject).to eq  ["Physical sciences", "Alberta", "1926", "w1200000/n0600000 w1100000/n0600000 w1100000/n0490000 w1200000/n05410xx1:1,900,800"]
      expect(mods_document.subLocation).to eq []
      expect(mods_document.subTitle).to eq []
      expect(mods_document.tableOfContents).to eq []
      expect(mods_document.targetAudience).to eq []
      expect(mods_document.temporal).to eq ["1926"]
      expect(mods_document.territory).to eq []
      expect(mods_document.text).to eq []
      expect(mods_document.title).to eq ["Geological map of the Province of Alberta, Canada"]
      expect(mods_document.titleInfo).to eq ["Geological map of the Province of Alberta, Canada"]
      expect(mods_document.topic).to eq ["Physical sciences"]
      expect(mods_document.total).to eq []
      expect(mods_document.typeOfResource).to eq ["cartographic"]
      expect(mods_document.url).to eq ["http://peel.library.ualberta.ca/maps/M/00/01/M000171/M000171.tif"]
    end
   
    it "should have the fields tagged for Solr indexing"
    
    describe "#to_solr" do
      it "should include Solr-tagged fields in a hash" do
        #expect(dublin_core_document.to_solr).to eq solr_hash
      end
    end
end
