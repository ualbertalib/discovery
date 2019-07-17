class Correction
  include ActiveModel::Model
  attr_accessor :message, :email, :catalog_id
  validates :message, presence: true
end
