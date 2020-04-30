class SolrMarcPrepGenerator < Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)

  def copy_location_facet_for_solr_marc
    template 'location_facet.bsh.erb', 'config/SolrMarc/index_scripts/location_facet.bsh', force: true
  end

  def copy_institution_for_solr_marc
    template 'institution.bsh.erb', 'config/SolrMarc/index_scripts/institution.bsh', force: true
  end
end
