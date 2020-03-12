class Location < ActiveRecord::Base
  belongs_to :library

  # These are the locations that indicate an electronic resource available to ualberta
  UNIVERSITY_OF_ALBERTA_INTERNET = 'UAINTERNET'.freeze
  NEOS_FREE_INTERNET_RESOURCES = 'NEOS_FREE'.freeze

  # When you see these libraries, show the UAL shield
  UAL_SHIELD_LIBRARIES = [
    Location.find_by(short_code: UNIVERSITY_OF_ALBERTA_INTERNET)&.name,
    Location.find_by(short_code: NEOS_FREE_INTERNET_RESOURCES)&.name
  ].freeze
end
