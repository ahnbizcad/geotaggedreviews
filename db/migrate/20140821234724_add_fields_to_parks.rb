class AddFieldsToParks < ActiveRecord::Migration
  def change
    add_column :parks, :address, :string    
  end
end
