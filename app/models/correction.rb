class Correction
  include ActiveModel::Model
  attr_accessor :message, :catalog_id
  validates :message, presence: true
end
