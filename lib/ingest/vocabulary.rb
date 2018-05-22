# frozen_string_literal: true

require 'om'
require 'solrizer'

class Vocabulary
  include OM::XML::Document
  include OM::XML::TerminologyBasedSolrizer
end
