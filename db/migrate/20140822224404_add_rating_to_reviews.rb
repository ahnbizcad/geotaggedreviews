class AddRatingToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :rating, :integer
    add_column :reviews, :comment, :text
  end
end
