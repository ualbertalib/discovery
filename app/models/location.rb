class Location < ActiveRecord::Base
  belongs_to :library

  UAL_SHIELD_LIBRARIES = [
    Location.find_by(short_code: :uainternet)&.name,
    Location.find_by(short_code: :neosfree)&.name
  ].freeze
end
