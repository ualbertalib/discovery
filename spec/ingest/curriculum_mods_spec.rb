require_relative "../spec_helper.rb"

include E

describe CurriculumModsVocabulary do

  let(:mods_document){ CurriculumModsVocabulary.from_xml(File.open(E::*("fixtures/curriculum_record.xml"))) }
  let(:solr_hash){ eval(File.open(E*("fixtures/curriculum_solr_hash")).read) }

    it "should be a Dublin Core OM vocabulary with a terminology-based solrizer" do
      expect(mods_document).to be_an_instance_of CurriculumModsVocabulary
      expect(mods_document).to be_a_kind_of OM::XML::Document
      expect(mods_document).to be_a_kind_of OM::XML::TerminologyBasedSolrizer
    end

    it "should hold all the MODS elements" do
      expect(mods_document.abstract).to eq []
      expect(mods_document.accessCondition).to eq []
      expect(mods_document.affiliation).to eq []
      expect(mods_document.area).to eq []
      expect(mods_document.caption).to eq []
      expect(mods_document.cartographics).to eq []
      expect(mods_document.city).to eq []
      expect(mods_document.citySection).to eq []
      expect(mods_document.classification).to eq []
      expect(mods_document.continent).to eq []
      expect(mods_document.coordinates).to eq []
      expect(mods_document.copyInformation).to eq []
      expect(mods_document.copyrightDate).to eq []
      expect(mods_document.county).to eq []
      expect(mods_document.country).to eq []
      expect(mods_document.date).to eq []
      expect(mods_document.dateCaptured).to eq []
      expect(mods_document.dateCreated).to eq []
      expect(mods_document.dateIssued).to eq ["[2000]-"]
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
      expect(mods_document.extent).to eq ["v. : ill. ; 28 cm."]
      expect(mods_document.form).to eq []
      expect(mods_document.frequency).to eq ["Annual"]
      expect(mods_document.marcgt_genre).to eq []
      expect(mods_document.genre).to eq ["diploma exams"]
      expect(mods_document.geographic).to eq []
      expect(mods_document.geographicCode).to eq []
      expect(mods_document.hierarchicalGeographic).to eq []
      expect(mods_document.holdingExternal).to eq []
      expect(mods_document.holdingSimple).to eq []
      expect(mods_document.identifier).to eq []
      expect(mods_document.internetMediaType).to eq []
      expect(mods_document.island).to eq []
      expect(mods_document.issuance).to eq []
      expect(mods_document.language).to eq ["english"]
      expect(mods_document.languageOfCataloging).to eq []
      expect(mods_document.languageTerm).to eq ["english"]
      expect(mods_document.list).to eq []
      expect(mods_document.location).to eq ["University of AlbertaLB 3054 C2 D525722"]
      expect(mods_document.personalName).to eq []
      expect(mods_document.corporateName).to eq ["Alberta. Alberta Learning"]
      expect(mods_document.namePart).to eq  ["Alberta. Alberta Learning"]
      expect(mods_document.nonSort).to eq []
      expect(mods_document.note).to eq ["Math 30", "Title from cover."]
      expect(mods_document.number).to eq []
      expect(mods_document.occupation).to eq []
      expect(mods_document.originInfo).to eq ["[Edmonton]Alberta Learning[2000]-Annual"]  # Finish breaking up nested fields
      expect(mods_document.part).to eq []
      expect(mods_document.partName).to eq []
      expect(mods_document.partNumber).to eq []
      expect(mods_document.physicalDescription).to eq  ["v. : ill. ; 28 cm."]
      expect(mods_document.place).to eq ["[Edmonton]"]
      expect(mods_document.placeTerm).to eq ["[Edmonton]"]
      expect(mods_document.projection).to eq []
      expect(mods_document.province).to eq []
      expect(mods_document.publisher).to eq ["Alberta Learning"]
      expect(mods_document.recordChangeDate).to eq []
      expect(mods_document.recordCreationDate).to eq []
      expect(mods_document.recordContentSource).to eq []
      expect(mods_document.recordIdentifier).to eq ["curr2568098"]
      expect(mods_document.recordInfo).to eq ["curr2568098"]
      expect(mods_document.recordOrigin).to eq []
      expect(mods_document.reformattingQuality).to eq []
      expect(mods_document.region).to eq []
      expect(mods_document.relatedItem).to eq ["Alberta Education Curriculum Collection/Collection Pédagogique"]
      expect(mods_document.role).to eq []
      expect(mods_document.roleTerm).to eq []
      expect(mods_document.scale).to eq []
      expect(mods_document.shelfLocator).to eq ["LB 3054 C2 D525722"]
      expect(mods_document.start).to eq []
      expect(mods_document.state).to eq []
      expect(mods_document.subject).to eq  ["mathematics", "math", "grade 12", "senior high school", "secondary", "senior high", "high school", "evaluation", "Mathematics--Alberta--Examinations, questions, etc.", "Twelfth grade (Education)--Alberta--Examinations."]
      expect(mods_document.subLocation).to eq []
      expect(mods_document.subTitle).to eq []
      expect(mods_document.tableOfContents).to eq []
      expect(mods_document.targetAudience).to eq ["senior high", "grade 12"]
      expect(mods_document.temporal).to eq []
      expect(mods_document.territory).to eq []
      expect(mods_document.text).to eq []
      expect(mods_document.title).to eq ["Applied mathematics 30, information bulletin, diploma examinations program.", "Alberta Education Curriculum Collection/Collection Pédagogique"]
      expect(mods_document.titleInfo).to eq ["Applied mathematics 30, information bulletin, diploma examinations program.", "Alberta Education Curriculum Collection/Collection Pédagogique"]

      expect(mods_document.topic).to eq ["mathematics", "math", "grade 12", "senior high school", "secondary", "senior high", "high school", "evaluation", "Mathematics--Alberta--Examinations, questions, etc.", "Twelfth grade (Education)--Alberta--Examinations."]
      expect(mods_document.total).to eq []
      expect(mods_document.typeOfResource).to eq ["text"]
      expect(mods_document.url).to eq []
    end

    it "should have the fields tagged for Solr indexing" do
      expect(mods_document.to_solr["dateIssued_tesim"]).to eq mods_document.dateIssued
      expect(mods_document.to_solr["frequency_tesim"]).to eq mods_document.frequency
      expect(mods_document.to_solr["extent_tesim"]).to eq mods_document.extent
      expect(mods_document.to_solr["genre_tesim"]).to eq mods_document.genre
      expect(mods_document.to_solr["language_tesim"]).to eq mods_document.language
      expect(mods_document.to_solr["languageTerm_tesim"]).to eq mods_document.languageTerm
      expect(mods_document.to_solr["location_tesim"]).to eq mods_document.location
      expect(mods_document.to_solr["corporateName_tesim"]).to eq mods_document.corporateName
      expect(mods_document.to_solr["namePart_tesim"]).to eq mods_document.namePart
      expect(mods_document.to_solr["note_tesim"]).to eq mods_document.note
      expect(mods_document.to_solr["originInfo_tesim"]).to eq mods_document.originInfo
      expect(mods_document.to_solr["physicalDescription_tesim"]).to eq mods_document.physicalDescription
      expect(mods_document.to_solr["place_tesim"]).to eq mods_document.place
      expect(mods_document.to_solr["placeTerm_tesim"]).to eq mods_document.placeTerm
      expect(mods_document.to_solr["publisher_tesim"]).to eq mods_document.publisher
      expect(mods_document.to_solr["recordIdentifier_tesim"]).to eq mods_document.recordIdentifier
      expect(mods_document.to_solr["recordInfo_tesim"]).to eq mods_document.recordInfo
      expect(mods_document.to_solr["relatedItem_tesim"]).to eq mods_document.relatedItem
      expect(mods_document.to_solr["subject_tesim"]).to eq mods_document.subject
      expect(mods_document.to_solr["shelfLocator_tesim"]).to eq mods_document.shelfLocator
      expect(mods_document.to_solr["title_tesim"]).to eq mods_document.title
      expect(mods_document.to_solr["titleInfo_tesim"]).to eq mods_document.titleInfo
      expect(mods_document.to_solr["topic_tesim"]).to eq mods_document.topic
      expect(mods_document.to_solr["typeOfResource_tesim"]).to eq mods_document.typeOfResource
      expect(mods_document.to_solr["targetAudience_tesim"]).to eq mods_document.targetAudience
    end

    describe "#to_solr" do
      it "should include Solr-tagged fields in a hash" do
        expect(mods_document.to_solr).to eq solr_hash
      end
    end
end
