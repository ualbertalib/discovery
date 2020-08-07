class RCRFSpecialRequest
  include ActiveModel::Model

  # FIXME: Should be from database or something, probably duplication with locations.yml
  # COVID-19: Curbside delivery is only at Rutherford
  LIBRARIES = [
    'University of Alberta Rutherford-Humanities & Social Science'
  ].freeze

  attr_accessor :name,
                :email,
                :title,
                :item_url,
                :notes,
                :library,
                :referer

  validates :name, presence: true
  validates :email, presence: true
  validates :title, presence: true
  validates :item_url, presence: true
  validates :notes, presence: true
  validates :library, presence: true
end
