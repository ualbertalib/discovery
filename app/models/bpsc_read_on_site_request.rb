class BPSCReadOnSiteRequest
  include ActiveModel::Model

  attr_accessor :name,
                :email,
                :appointment_time,
                :title,
                :call_number,
                :item_url,
                :notes,
                :referer

  validates :name, presence: true
  validates :email, presence: true
  validates :appointment_time, presence: true
  validates :title, presence: true
  validates :call_number, presence: true
  validates :item_url, presence: true
end
