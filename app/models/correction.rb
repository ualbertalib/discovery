class Correction
  include ActiveModel::Model
  attr_accessor :message, :item_id
  validates :message, presence: true
end
