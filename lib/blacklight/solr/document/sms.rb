
# frozen_string_literal: true

# This module provides the body of an email export based on the document's semantic values
module Blacklight::Solr::Document::Sms
  # Return a text string that will be the body of the email
  def to_sms_text
    # locations ||= YAML.load_file("#{Rails.root}/config/locations.yml")
    # body = []
    # body << self.to_h["lc_callnum_display"]
    # body << locations[self.to_h["location_tesim"].first.downcase]
    # return body.join("\n") unless body.empty?
  end
end
