class LinkParksToReviews < ActiveRecord::Migration
  def change
    add_reference :reviews, :park, index: true
  end
end
