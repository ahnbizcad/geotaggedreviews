class AddNameToParks < ActiveRecord::Migration
  def change
    add_column :parks, :name, :string
  end
end
