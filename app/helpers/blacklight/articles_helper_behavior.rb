# -*- encoding : utf-8 -*-

##
# Copyright 2013 EBSCO Information Services
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

module Blacklight::ArticlesHelperBehavior
  ############
  # Utility functions and libraries
  ############
  
  require 'fileutils' # for interacting with files
  require "addressable/uri" # for manipulating URLs in the interface
  require "htmlentities" # for deconding/encoding URLs
  require "cgi"
  require 'open-uri'
  require_relative './api_interaction'
  require_relative './linking_utilities'
  require_relative './pagination.rb'
  require_relative './facets_limits'
  require_relative './results_records'
  require_relative './full_text_links'
  require_relative './auth_functions'

  include Blacklight::API_Interaction
  include Blacklight::Linking_Utilities
  include Blacklight::Pagination
  include Blacklight::Facets_Limits
  include Blacklight::Results_Records
  include Blacklight::Full_Text_Links
  include Blacklight::Auth_Functions

  def html_unescape(text)
    return CGI.unescape(text)
  end
  
  def deep_clean(parameters)
    tempArray = Array.new;
    parameters.each do |k,v|    
      unless v.nil?
        if v.is_a?(Array)
          deeperClean = deep_clean(v)
          parameters[k] = deeperClean
        else
          parameters[k] = h(v)
        end
      else
          clean_key = h(k)
          tempArray.push(clean_key)
      end
    end
    unless tempArray.empty?
      parameters = tempArray
    end
    return parameters
  end

  # cleans response from EBSCO API
  def processAPItags(apiString)
    processed = HTMLEntities.new.decode apiString
    return processed.html_safe
  end

  
  ################
  # Debug Functions
  ################
	
  def show_query_string
    return @results['queryString']
  end
  
  def debugNotes
    #return session[:debugNotes] << "<h4>API Calls</h4>" << @connection.debug_notes
  end

	
end
