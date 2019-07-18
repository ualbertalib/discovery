class RCRFReadOnSiteRequest
  include ActiveModel::Model

  VIEWING_LOCATIONS = [
    'Bruce Peel Special Collection (Mon-Fri 12-4:30pm)',
    'Archives Reading Room - RCRF (Tues-Thurs 9-4pm)'
  ].freeze

  attr_accessor :name,
                :email,
                :viewing_location,
                :appointment_time,
                :title,
                :item_url,
                :notes,
                :referer

  validates :name, presence: true
  validates :email, presence: true
  validates :viewing_location, presence: true
  validates :appointment_time, presence: true
  validates :title, presence: true
  validates :item_url, presence: true
end
