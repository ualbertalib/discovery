class Location < ActiveRecord::Base
  belongs_to :library

  UAL_SHIELD_LIBRARIES = [
    Location.find_by(short_code: 'UAINTERNET')&.name,
    Location.find_by(short_code: 'NEOS_FREE')&.name
  ].freeze
end
