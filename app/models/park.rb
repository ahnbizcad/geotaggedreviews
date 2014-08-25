class Park < ActiveRecord::Base
  mount_uploader :image, ImageUploader

  has_many :reviews

  validates :address, :image, presence: true
  validates :address, format: { with: /\d+.+/}
end
