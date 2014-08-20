require_relative "./vocabulary"

class PeelModsVocabulary < Vocabulary

  set_terminology do |t|
    t.root(path: "mods", xmlns: "http://www.loc.gov/mods/v3")
    t.abstract
    t.accessCondition
    t.affiliation
    t.area
    t.caption
    t.cartographics
    t.city
    t.citySection
    t.classification
    t.continent
    t.coordinates
    t.copyInformation
    t.copyrightDate
    t.county
    t.country
    t.date
    t.dateCaptured
    t.dateCreated
    t.dateIssued
    t.dateModified
    t.dateOther
    t.description
    t.descriptionStandard
    t.detail
    t.digitalOrigin
    t.displayForm
    t.edition
    t.electronicLocator
    t.end
    t.enumerationAndChronology
    t.etal
    t.extension
    t.extent
    t.form
    t.frequency
    t.marcgt_genre(:path=>"genre", :attributes => {"authority" => "marcgt"})
    t.genre(:path=>"genre", :attributes=>{"authority"=>:none})
    t.geographic
    t.geographicCode
    t.hierarchicalGeographic
    t.holdingExternal
    t.holdingSimple
    t.identifier
    t.internetMediaType
    t.island
    t.issuance
    t.language
    t.languageOfCataloging
    t.languageTerm
    t.list
    t.location
    t.personalName(:path=>"name", :attributes=>{"type" => "personal"})
    t.corporateName(:path=>"name", :attributes=>{"type" => "corporate"})
    t.namePart
    t.nonSort
    t.note
    t.number
    t.occupation
    t.originInfo
    t.part
    t.partName
    t.partNumber
    t.physicalDescription
    t.place
    t.placeTerm
    t.projection
    t.province
    t.publisher
    t.recordChangeDate
    t.recordCreationDate
    t.recordContentSource
    t.recordIdentifier
    t.recordInfo
    t.recordOrigin
    t.reformattingQuality
    t.region
    t.relatedItem
    t.role
    t.roleTerm
    t.scale
    t.shelfLocator
    t.start
    t.state
    t.subject
    t.subLocation
    t.subTitle
    t.tableOfContents
    t.targetAudience
    t.temporal
    t.territory
    t.text
    t.title
    t.titleInfo
    t.topic
    t.total
    t.typeOfResource
    t.url
  end

end
