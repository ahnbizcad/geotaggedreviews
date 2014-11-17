class Park < ActiveRecord::Base
  #mount_uploader :image, ImageUploader #CarrierWave
  searchkick

  has_many :reviews

  validates :address, presence: true
  validates :address, uniqueness: true
  #validates :address, format: { with: /\d+.+/}

  #

  def average_rating
    reviews.any? ? reviews.average(:rating).round(2) : 0
  end

  def the_reviews
    Review.of_park(self).includes(:user).by_newest
  end

  def reviews_count
    reviews.size
  end

  def ratings_histogram
    ratings_histogram = Array.new(5, 0)
    if reviews.any?
      5.downto(1).each_with_index do |val, index|
        ratings_histogram[index] = reviews.with_stars(val).size
      end
    end
    ratings_histogram
  end

  def percentages
    percentages = Array.new(5, 0)
    if reviews.any?
      5.downto(1).each_with_index do |val, index|
        percentages[index] = (reviews.with_stars(val).size) * 100 / (reviews_count)
      end
    end
    percentages
  end

end
