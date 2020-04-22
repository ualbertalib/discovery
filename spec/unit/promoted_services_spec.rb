require_relative '../spec_helper.rb'

describe PromotedServicesVocabulary do
  let(:service_document) do
    PromotedServicesVocabulary.from_xml(Nokogiri::XML(File.open(
                                                        Rails.root.join('spec', 'fixtures', 'era_record.xml')
                                                      )).xpath('//record').to_s)
  end

  it 'should be a Promoted Services Vocabulary with solrizer' do
    expect(service_document).to be_an_instance_of PromotedServicesVocabulary
    expect(service_document).to be_a_kind_of OM::XML::Document
    expect(service_document).to be_a_kind_of OM::XML::TerminologyBasedSolrizer
  end

  it 'should hold all the right fields' do
    expect(service_document.id).to eq ['service002']
    expect(service_document.title).to eq ['ERA (Education &amp; Research Archive)']
    expect(service_document.url).to eq ['https://era.library.ualberta.ca/public/home']
    expect(service_document.source).to eq ['services']
    expect(service_document.format).to eq ['service']
  end

  it 'should have the fields tagged for Solr indexing' do
    expect(service_document.to_solr['id_tesim']).to eq service_document.id
    expect(service_document.to_solr['title_tesim']).to eq service_document.title
    expect(service_document.to_solr['url_tesim']).to eq service_document.url
    expect(service_document.to_solr['source_tesim']).to eq service_document.source
    expect(service_document.to_solr['format_tesim']).to eq service_document.format
  end
end
