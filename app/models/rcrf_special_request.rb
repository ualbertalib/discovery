class RCRFSpecialRequest
  include ActiveModel::Model

  # FIXME: Should be from database or something, probably duplication with locations.yml
  LIBRARIES = [
    'University of Alberta Augustana',
    'University of Alberta Bibliothèque Saint-Jean',
    'University of Alberta Cameron-Science & Technology',
    'University of Alberta HT Coutts-Education and Kinesiology, Sport, and Recreation',
    'University of Alberta JA Weir-Law',
    'University of Alberta JW Scott-Health Sciences',
    'University of Alberta Rutherford-Humanities & Social Science',
    "University of Alberta St Joseph's College",
    'University of Alberta Winspear-Business'
  ].freeze

  attr_accessor :name,
                :email,
                :title,
                :item_url,
                :notes,
                :library

  validates :name, presence: true
  validates :email, presence: true
  validates :title, presence: true
  validates :item_url, presence: true
  validates :notes, presence: true
  validates :library, presence: true
end
