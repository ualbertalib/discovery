class RCRFReadOnSiteRequest
  include ActiveModel::Model

  attr_accessor :name,
                :email,
                :viewing_location,
                :appointment_time,
                :title,
                :item_url,
                :notes

  validates :name, presence: true
  validates :email, presence: true
  validates :viewing_location, presence: true
  validates :appointment_time, presence: true
  validates :title, presence: true
  validates :item_url, presence: true
end
