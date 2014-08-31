class RenameImageToImageUrlForParks < ActiveRecord::Migration
  def change
    rename_column :parks, :image, :image_url
  end
end
