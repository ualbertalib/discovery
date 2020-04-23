require 'generator_spec/test_case'
require 'generators/solr_marc_prep/solr_marc_prep_generator'

describe SolrMarcPrepGenerator, type: :generator do
  destination File.expand_path('../tmp', __dir__)

  before(:all) do
    prepare_destination
    run_generator
  end

  it 'creates a institutions beanshell mapping script' do
    Location.create(short_code: 'UAINTERNET', symphony_id: '44', name: 'University of Alberta Internet')
    run_generator
    assert_file 'config/SolrMarc/index_scripts/institution.bsh', 'institution_codes.put("44", "University of Alberta");'
  end

  it 'creates a location facets beanshell mapping script' do
    assert_file 'config/SolrMarc/index_scripts/location_facet.bsh'
  end
end
