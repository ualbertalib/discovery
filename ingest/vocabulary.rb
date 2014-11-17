require "om"
require "solrizer"

class Vocabulary
  include OM::XML::Document
  include OM::XML::TerminologyBasedSolrizer
end
