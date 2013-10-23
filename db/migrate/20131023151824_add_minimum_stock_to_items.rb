class AddMinimumStockToItems < ActiveRecord::Migration
  def change
    add_column :items, :minimum_stock, :integer
  end
end
