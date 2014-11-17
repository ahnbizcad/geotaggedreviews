class Park < ActiveRecord::Base
  #mount_uploader :image, ImageUploader #CarrierWave
  searchkick

  has_many :reviews

  validates :address, presence: true
  #validates :address, format: { with: /\d+.+/}

end
