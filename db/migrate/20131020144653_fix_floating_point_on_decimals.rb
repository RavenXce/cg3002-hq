class FixFloatingPointOnDecimals < ActiveRecord::Migration
  def change
    change_column :items, :cost_price, :decimal, :precision => 10, :scale => 2
    change_column :shop_items, :selling_price, :decimal, :precision => 10, :scale => 2
    change_column :sales, :price, :decimal, :precision => 10, :scale => 2
  end
end
