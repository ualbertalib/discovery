require_relative "../spec_helper.rb"

describe DatabaseVocabulary do
  let(:database) do
    DatabaseVocabulary.from_xml(File.open(
                                  Rails.root.join('spec', 'fixtures', "database_record.xml")
                                ))
  end

  it "should be a database OM Vocabulary with a terminology-based solrizer" do
    expect(database).to be_an_instance_of DatabaseVocabulary
    expect(database).to be_a_kind_of OM::XML::Document
    expect(database).to be_a_kind_of OM::XML::TerminologyBasedSolrizer
  end

  it "should hold all the database object fields" do
    expect(database.id).to eq ["9963538"]
    expect(database.title).to eq ["CAB Abstracts"]
    expect(database.databasedescription.first).to eq "CAB Abstracts (1910 to the present) includes international coverage of all aspects of agriculture, horticulture, animal production and forestry including: crop production, plant protection and breeding; forestry and forest products; soil science, land use and water management; animal husbandry, health, breeding, nutrition and parasitology; dairy science and technology, agricultural engineering; economics; rural development, sociology and education; leisure, recreation and tourism.<br />Many topics in the sciences basic to these activities are also covered, including the physiology, biochemistry, ecology, genetics, and biosystematics of the plants, animals, and microorganisms that are indexed as domesticated organisms, genetic resources, pests, pathogens, hosts, or potential economic resources. In human health and medicine, the emphasis is on: human nutrition, community and public health, tropical diseases, communicable diseases including AIDS, medical mycology, entomology, and parasitology. CABI = Centre for Agriculture and Biosciences International.<br />\n<br />\nAlso includes full text from a number of journals, conference proceedings, and review articles."
    expect(database.url).to eq ["http://www.library.ualberta.ca/databases/databaseinfo/index.cfm?ID=47"]
    expect(database.enableproxy).to eq ["1"]
    expect(database.subject).to eq ["Aboriginal Sport & Recreation", "Agricultural, Food & Nutritional Science", "Agricultural, Life and Environmental Sciences", "Agriculture", "Animal Science", "Biochemistry", "Chemical Engineering", "Crops & Food", "Environnement", "Food Science", "Forest Economics", "Forest Sciences", "Human Ecology", "Nanotechnology", "Physiology", "Plant Science", "Renewable  Resources", "Resource Economics & Environmental Sociology", "Soil Science"]
  end

  it "should have the fields tagged for solr indexing" do
    expect(database.to_solr["id_tesim"]).to eq database.id
    expect(database.to_solr["title_tesim"]).to eq database.title
    expect(database.to_solr["databasedescription_tesim"]).to eq database.databasedescription
    expect(database.to_solr["url_tesim"]).to eq database.url
    expect(database.to_solr["enableproxy_tesim"]).to eq database.enableproxy
    expect(database.to_solr["subject_tesim"]).to eq database.subject
  end
end
