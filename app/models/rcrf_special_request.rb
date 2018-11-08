class RCRFSpecialRequest
  include ActiveModel::Model

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
